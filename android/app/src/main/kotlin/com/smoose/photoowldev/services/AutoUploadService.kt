package com.smoose.photoowldev.services

import android.Manifest
import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.smoose.photoowldev.R
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.dart.DartExecutor
import com.smoose.photoowldev.MethodChannelHolder

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
    private lateinit var overlayView: View
    private var isSharingOn: Boolean = true
    private lateinit var sharedPrefs: SharedPreferences
    private var fileObserver: ImageFileObserver? = null
    private var serviceState: Int = 0
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
            if (key == "sharing_status") {
                getPersistedShareStatus()
                val imageView =
                    overlayView.findViewById<ImageView>(R.id.imageView)
                if (serviceState == ServiceState.START_SHARING) {

                    startSharing()
                } else {
                    stopSharing()
                }
                if (isSharingOn) {
                    imageView.setImageResource(R.drawable.bringer_logo)
                } else {
                    imageView.setImageResource(R.drawable.bringer_logo_bandw)
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
        overlayView =
            LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
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
        val flutterEngine: FlutterEngine = FlutterEngine(this)
        flutterEngine.getDartExecutor().executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        val channel: MethodChannel =
            MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.smoose.photoowldev/autoUpload")
        MethodChannelHolder.serviceMethodChannel = channel
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
        if (fileObserver == null) {
            fileObserver = ImageFileObserver(this)
        }
        fileObserver?.startWatching()
    }

    private fun registerPreferenceChangeListener() {
        sharedPrefs.registerOnSharedPreferenceChangeListener(prefsListener)
    }

    private fun unregisterPreferenceChangeListener() {
        sharedPrefs.unregisterOnSharedPreferenceChangeListener(prefsListener)
    }

    private fun stopObserving() {
        fileObserver?.stopWatching()

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
        isSharingOn = true
        serviceState = ServiceState.START_SHARING
        showToolTip()
//        sharedPrefs.edit().putBoolean("sharing_status", true).apply()
//        observer = GalleryObserver(applicationContext).apply { attach() }
        startObserving()
        startUsageStatsTask()
        updatePersistentNotification()
    }

    private fun stopSharing() {
        isSharingOn = false
        serviceState = ServiceState.STOP_SHARING
        showToolTip()
//        sharedPrefs.edit().putBoolean("sharing_status", false).apply()
//        observer?.apply { detach() }?.let { observer = null }
        stopObserving()
        updatePersistentNotification()
    }

    private fun startUsageStatsTask() {
        handler.post(runnable)
    }

    private fun getPersistedShareStatus() {
        isSharingOn = sharedPrefs.getBoolean("sharing_status", true)
        serviceState =
            if (isSharingOn) ServiceState.START_SHARING else ServiceState.STOP_SHARING
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

        overlayView.setOnTouchListener { v, event ->
            if (event.action == MotionEvent.ACTION_DOWN) {
                overlayOnClick()
                true
            } else {
                false
            }
        }
        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        val popupType =
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O)
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE
            else
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            popupType,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.START
        windowManager.addView(overlayView, params)
        showToolTip()
    }

    private fun showToolTip() {
        val toolTipLayout =
            overlayView.findViewById<LinearLayout>(R.id.toolTipLayout)
        //check for status and update the text and icon
        val bubbleText = overlayView.findViewById<TextView>(R.id.bubbleText)
        val bubbleIcon = overlayView.findViewById<ImageView>(R.id.statusIcon)
        if (isSharingOn) {
            bubbleText.text = getString(R.string.chat_message_on)
            bubbleIcon.setImageResource(R.drawable.status_icon_on)
        } else {
            bubbleText.text = getString(R.string.chat_message_off)
            bubbleIcon.setImageResource(R.drawable.status_icon_off)
        }

        //animate the tool tip
        val animator = ObjectAnimator.ofFloat(toolTipLayout, "alpha", 0f, 1f)
        animator.duration = 700 // Duration of the animation in milliseconds
        animator.start()
        // Create a Handler to post delayed runnable
        val handler = Handler(Looper.getMainLooper())
        handler.postDelayed({
            // Define the second animation to fade back to 0f
            val reverseAnimator =
                ObjectAnimator.ofFloat(toolTipLayout, "alpha", 1f, 0f)
            reverseAnimator.duration =
                700 // Reverse animation duration in milliseconds
            reverseAnimator.start()

        }, 1200)

    }

    private fun hidePopUp() {
        if (overlayView != null && overlayView.parent != null) {
            (getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(
                overlayView
            )

        }
    }

    private fun overlayOnClick() {
        Log.d(LOG_TAG, "overlay click detected")
        val imageView = overlayView.findViewById<ImageView>(R.id.imageView)
        if (isSharingOn) {

            stopSharing()
        } else {

            startSharing()
        }
    }

    private fun getUsageStatsForPackage(packageName: String) {
        val editor = sharedPrefs.edit()
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 1000  // 1 hour ago
        val query = UsageStatsManager.INTERVAL_DAILY
        val stats = usageStatsManager.queryUsageStats(query, startTime, endTime)
        if (stats != null && stats.isNotEmpty()) {
            for (usageStats in stats) {
                if (usageStats.packageName == packageName) {

                    val lastTimeUsed = usageStats.lastTimeUsed
                    val totalTimeInForeground = usageStats.totalTimeInForeground
                    Log.d(
                        LOG_TAG,
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
                            LOG_TAG,
                            "First time detected"
                        )

                    } else {
                        if ((oldCameraLastTimeUsed != lastTimeUsed.toString()) && (oldCameraTotalTimeInForeground == totalTimeInForeground.toString())) {
                            Log.d(
                                LOG_TAG,
                                "CAMERA OPEN DETECTED"
                            )
                            showPopUp()
                        } else if ((oldCameraLastTimeUsed != lastTimeUsed.toString()) && (oldCameraTotalTimeInForeground != totalTimeInForeground.toString())) {

                            Log.d(
                                LOG_TAG,
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