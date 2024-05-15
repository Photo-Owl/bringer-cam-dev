package com.smoose.photoowldev.services

import android.Manifest
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.smoose.photoowldev.AppState
import com.smoose.photoowldev.R
import java.io.File
import android.os.Environment
import android.database.Cursor
import android.net.Uri


internal class ServiceState {
    companion object {
        @JvmStatic
        val INIT = 0
        @JvmStatic
        val START_SHARING = 1
        @JvmStatic
        val STOP_SHARING = 2
        @JvmStatic
        val INIT_SIGNED_IN = 3
    }
}

class AutoUploadService : Service() {
//    private var observer: GalleryObserver? = null
    private var fileObserver: ImageFileObserver? =null;
    private var serviceState: Int = 0
    private lateinit var sharedPrefs: SharedPreferences
    private val handler = Handler(Looper.getMainLooper())
    private val runnable = object : Runnable {
        override fun run() {
            val defaultCameraApp = getDefaultCameraApp()
            if (defaultCameraApp != null)
                getUsageStatsForPackage(defaultCameraApp)
            handler.postDelayed(
                this,
                1000
            ) // Schedule the task to run every 1 second
        }
    }

    private val prefsListener =
        SharedPreferences.OnSharedPreferenceChangeListener { _, key ->
            if (key == "sharing_status"){
                getPersistedShareStatus()
                if(serviceState == ServiceState.START_SHARING){
                    startSharing()
                }else{
                    stopSharing()
                }
            }

        }

    companion object {
        @JvmStatic
        private var isInitialized = false

        @JvmStatic
        fun isInitialized(): Boolean = isInitialized

        @JvmStatic
        private val LOG_TAG = "bringer/autoUploadDebug"

        @JvmStatic
        private val CHANNEL_ID = "com.smoose.photoowldev.autoUploadServiceNotif"

        @JvmStatic
        private val SERVICE_ID = 1

        @JvmStatic
        val SERVICE_STATE_EXTRA = "service_state"
    }

    override fun onCreate() {
        super.onCreate()
        sharedPrefs = getSharedPreferences(
            "bringer_shared_preferences",
            Context.MODE_PRIVATE
        )
        getPersistedShareStatus()
        sharedPrefs.registerOnSharedPreferenceChangeListener(prefsListener)
    }

    override fun onDestroy() {
        sharedPrefs.unregisterOnSharedPreferenceChangeListener(prefsListener)
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {
        val newState = intent?.extras?.getInt(SERVICE_STATE_EXTRA, 0) ?: 0
        when (newState) {
            ServiceState.INIT -> initializeService(isSignedIn = false)
            ServiceState.START_SHARING -> startSharing()
            ServiceState.STOP_SHARING -> stopSharing()
            ServiceState.INIT_SIGNED_IN -> initializeService(isSignedIn = true)
        }
        return START_STICKY
    }

    private fun startObserving() {
        fileObserver = ImageFileObserver(this)
        fileObserver?.startWatching()
    }

    private fun stopObserving() {
        fileObserver?.stopWatching()
        fileObserver = null
    }
    private fun initializeService(isSignedIn: Boolean = false) {
        isInitialized = true
//        observer = GalleryObserver(applicationContext).apply { attach() }
        startObserving()
        with(NotificationManagerCompat.from(applicationContext)) {
            if (getNotificationChannel(CHANNEL_ID) == null) {
                val notifChannel = NotificationChannelCompat.Builder(
                    CHANNEL_ID,
                    NotificationManagerCompat.IMPORTANCE_MIN
                )
                    .setName(getString(R.string.auto_upload_channel))
                    .build()
                createNotificationChannel(notifChannel)
            }
        }

        if (!isSignedIn) {
            serviceState = ServiceState.INIT
        } else {
            getPersistedShareStatus()
            if (serviceState == ServiceState.START_SHARING) {
                startUsageStatsTask()
            }
        }
        startForeground(SERVICE_ID, createPersistentNotification())
    }

    private fun startSharing() {
        serviceState = ServiceState.START_SHARING
        sharedPrefs.edit().putBoolean("sharing_status", true).apply()
//        observer = GalleryObserver(applicationContext).apply { attach() }
        startObserving()
        startUsageStatsTask()
        updatePersistentNotification()
    }

    private fun stopSharing() {
        serviceState = ServiceState.STOP_SHARING
        sharedPrefs.edit().putBoolean("sharing_status", false).apply()
//        observer?.apply { detach() }?.let { observer = null }
        stopObserving()
        updatePersistentNotification()
    }

    private fun startUsageStatsTask() {
        handler.post(runnable)
    }

    private fun getPersistedShareStatus() {
        val isSharingOn = sharedPrefs.getBoolean("sharing_status", true)
        serviceState = if (isSharingOn) ServiceState.START_SHARING else ServiceState.STOP_SHARING
    }

    private fun getDefaultCameraApp(): String? {
        // Query for the default camera app
        val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val cameraApps = packageManager.queryIntentActivities(
            cameraIntent,
            PackageManager.MATCH_DEFAULT_ONLY
        )

        // Assuming there's at least one camera app
        val defaultCameraApp = cameraApps.firstOrNull()
        if (defaultCameraApp != null) {
            val packageName = defaultCameraApp.activityInfo.packageName
            return packageName
        } else {
            return null
        }
    }

    private fun showPopUp() {
        val intent = Intent(this, OverlayService::class.java)
        startService(intent)
    }

    private fun hidePopUp() {
        val intent = Intent(this, OverlayService::class.java)
        stopService(intent)
    }

    private fun getUsageStatsForPackage(packageName: String) {
        val editor = sharedPrefs.edit()
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 1000 * 60 * 60 // 1 hour ago
        val query = UsageStatsManager.INTERVAL_DAILY
        val stats = usageStatsManager.queryUsageStats(query, startTime, endTime)
        if (stats != null && stats.isNotEmpty()) {
            for (usageStats in stats) {
                if (usageStats.packageName == packageName) {

                    val lastTimeUsed = usageStats.lastTimeUsed
                    val totalTimeInForeground = usageStats.totalTimeInForeground
                    Log.d(
                            "mainActivity debug usage stats",
                            "CAMERA PACKAGE - LAST TIME USED $lastTimeUsed and TOTAL TIME IN FOREGROUND $totalTimeInForeground"
                    )
                    // Check if variables exist in shared preferences
                    val oldCameraLastTimeUsed =
                        sharedPrefs.getString("camera_last_time_used", "")
                    val oldCameraTotalTimeInForeground =
                        sharedPrefs.getString(
                            "camera_total_time_in_foreground",
                            ""
                        )

                    // If variables are not present, initialize them
                    if (oldCameraLastTimeUsed!!.isEmpty() || oldCameraTotalTimeInForeground!!.isEmpty()) {
                        Log.d(
                            "mainActivity debug usage stats",
                            "First time detected"
                        )

                    } else {
                        if ((oldCameraLastTimeUsed != lastTimeUsed.toString()) && (oldCameraTotalTimeInForeground == totalTimeInForeground.toString())) {
                            Log.d(
                                "mainActivity debug usage stats",
                                "CAMERA OPEN DETECTED"
                            )
                            showPopUp()
                        } else if ((oldCameraLastTimeUsed != lastTimeUsed.toString()) && (oldCameraTotalTimeInForeground != totalTimeInForeground.toString())) {

                            Log.d(
                                "mainActivity debug usage stats",
                                "CAMERA CLOSE DETECTED - LAST TIME USED $lastTimeUsed and TOTAL TIME IN FOREGROUND $totalTimeInForeground"
                            )

                            hidePopUp()
                        }

                    }
                    editor.putString(
                        "camera_last_time_used",
                        lastTimeUsed.toString()
                    )
                    editor.putString(
                        "camera_total_time_in_foreground",
                        totalTimeInForeground.toString()
                    )
                    editor.apply()
                    break
                }

            }
        }
    }

    private fun updatePersistentNotification() {
        val notifManager = NotificationManagerCompat.from(applicationContext)

        val canSend = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        else true

        if (!canSend) return

        notifManager.notify(SERVICE_ID, createPersistentNotification())
    }

    private fun createPersistentNotification(): Notification {
        val contentText = getString(
            when (serviceState) {
                ServiceState.START_SHARING -> R.string.auto_upload_notif_body_on
                ServiceState.STOP_SHARING -> R.string.auto_upload_notif_body_off
                else -> R.string.auto_upload_notif_body_inactive
            }
        )

        val notifBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.auto_upload_notif_title))
            .setSubText(getString(R.string.auto_upload_notif_sub_text))
            .setContentText(contentText)
            .setSmallIcon(R.drawable.ic_mono)
            .setAutoCancel(false)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_MIN)

        if (serviceState != ServiceState.INIT) {
            val isStartSharing = serviceState == ServiceState.START_SHARING
            val newState =
                if (isStartSharing) ServiceState.STOP_SHARING
                else ServiceState.START_SHARING
            val intent = Intent(applicationContext, this::class.java)
                .putExtra(SERVICE_STATE_EXTRA, newState)
            val action = NotificationCompat.Action(
                R.drawable.ic_mono,
                getString(
                    if (isStartSharing) R.string.auto_upload_toggle_off
                    else R.string.auto_upload_toggle_on
                ),
                PendingIntent.getService(
                    this, SERVICE_ID, intent,
                    PendingIntent.FLAG_IMMUTABLE
                            or PendingIntent.FLAG_UPDATE_CURRENT
                )
            )
            notifBuilder.addAction(action)
        }

        return notifBuilder.build()
    }
}