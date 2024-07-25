package com.smoose.photoowldev.services

import android.Manifest
import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.app.usage.*
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
import androidx.core.content.ContextCompat
import androidx.appcompat.app.AppCompatActivity
import com.smoose.photoowldev.R
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.dart.DartExecutor
import com.smoose.photoowldev.MethodChannelHolder
import android.widget.Space
import android.animation.Animator
import android.animation.Animator.AnimatorListener
import android.view.ViewGroup

internal class ServiceState {
    companion object {
        @Deprecated("Not used since v13")
        @JvmStatic
        val INIT = 0

        @JvmStatic
        val START_SHARING = 1

        @JvmStatic
        val STOP_SHARING = 2

        @Deprecated("Not used since v13")
        @JvmStatic
        val INIT_SIGNED_IN = 3
    }
}

class AutoUploadService : Service() {
    //For - moveable
    private lateinit var windowManager: WindowManager
    private lateinit var params: WindowManager.LayoutParams
    private var initialX: Int = 0
    private var initialY: Int = 0
    private var initialTouchX: Float = 0f
    private var initialTouchY: Float = 0f
    //
    //For - toot-tip
    private lateinit var overlayView: View
    private lateinit var toolTipLayout: LinearLayout
    private lateinit var bubbleText: TextView
    private lateinit var statusIcon: ImageView
    //
    private var isSharingOn: Boolean = true
    private lateinit var sharedPrefs: SharedPreferences
    private var fileObserver: ImageFileObserver? = null
    private var serviceState: Int = ServiceState.START_SHARING
    private val handler = Handler(Looper.getMainLooper())
    private var isPopUpShowing: Boolean = false
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
        Log.d(LOG_TAG, "onCreate Called")
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
        Log.d(LOG_TAG, "onStartCommand")

        val channel: MethodChannel =
            MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.smoose.photoowldev/autoUpload")
        MethodChannelHolder.serviceMethodChannel = channel
        val newState = intent?.extras?.getInt(SERVICE_STATE_EXTRA, 1) ?: 1

        when (newState) {
            ServiceState.START_SHARING -> startSharing()
            ServiceState.STOP_SHARING -> stopSharing()
        }
        Log.d(LOG_TAG, "onStartCommand returning start_sticky")
        return START_STICKY
    }

    private fun startObserving() {
        if (fileObserver == null) {
            fileObserver = ImageFileObserver(this)
        }
        fileObserver?.startWatching()
    }

    private fun stopObserving() {
        fileObserver?.stopWatching()

    }

    private fun initializeService() {
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

        getPersistedShareStatus()
        if (serviceState == ServiceState.START_SHARING)
            startUsageStatsTask()
        startForeground(SERVICE_ID, createPersistentNotification())
    }

    private fun startSharing() {
        if (!isInitialized) initializeService()
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
        if (!isInitialized) initializeService()
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
        if(isPopUpShowing) return

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
            params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            popupType,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP or Gravity.START
        params.x = 0
        params.y = 100
        overlayView.setOnTouchListener(object : View.OnTouchListener {
            override fun onTouch(v: View?, event: MotionEvent): Boolean {
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        initialX = params.x
                        initialY = params.y
                        initialTouchX = event.rawX
                        initialTouchY = event.rawY
                        return true
                    }
                    MotionEvent.ACTION_MOVE -> {
                        params.x = initialX + (event.rawX - initialTouchX).toInt()
                        params.y = initialY + (event.rawY - initialTouchY).toInt()
                        windowManager.updateViewLayout(overlayView, params)
                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        val moved = Math.abs(event.rawX - initialTouchX) > 5 ||
                                Math.abs(event.rawY - initialTouchY) > 5
                        if (!moved) {
                            overlayOnClick()
                        }
                        return true
                    }
                }
                return false
            }
        })
        windowManager.addView(overlayView, params)
        showToolTip()
        isPopUpShowing = true
    }
    private fun dpToPx(dp: Int): Int {
        val density = resources.displayMetrics.density
        return (dp * density).toInt()
    }
    private fun createTooltip(): Triple<LinearLayout, TextView, ImageView>  {
        // Create the main LinearLayout
        val toolTipLayout = LinearLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER
            orientation = LinearLayout.HORIZONTAL
            id = resources.getIdentifier("toolTipLayout", "id", packageName)
        }

        // Add Space
        val space = Space(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                dpToPx(6),
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }
        toolTipLayout.addView(space)

        // Add triangle ImageView
        val triangleImageView = ImageView(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.CENTER
            }
            setImageResource(R.drawable.triangle_pointer)
            contentDescription = getString(R.string.chat_bubble_triangle)
        }
        toolTipLayout.addView(triangleImageView)

        // Create inner LinearLayout
        val innerLayout = LinearLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.CENTER
            }
            orientation = LinearLayout.HORIZONTAL
            setBackgroundResource(R.drawable.chat_bubble_shape)
        }

        val bubbleText = TextView(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER_VERTICAL or Gravity.START
            setPadding(0, dpToPx(6), dpToPx(6), dpToPx(6))
            text = getString(R.string.chat_message_on)
            textSize = 16f
            setTextColor(ContextCompat.getColor(context, android.R.color.darker_gray))
            id = resources.getIdentifier("bubbleText", "id", packageName)
        }

        val statusIcon = ImageView(this).apply {
            layoutParams = LinearLayout.LayoutParams(dpToPx(24), dpToPx(24)).apply {
                gravity = Gravity.CENTER
            }
            setPadding(dpToPx(6), dpToPx(6), dpToPx(6), dpToPx(6))
            setImageResource(R.drawable.status_icon_on)
            id = resources.getIdentifier("statusIcon", "id", packageName)
        }

        innerLayout.addView(statusIcon)
        innerLayout.addView(bubbleText)
        // Add inner LinearLayout to main LinearLayout
        toolTipLayout.addView(innerLayout)

        return Triple(toolTipLayout, bubbleText, statusIcon)
    }



    private fun showToolTip() {
            val existingTooltip = overlayView.findViewById<View>(R.id.toolTipLayout)
        if (existingTooltip != null) {
            Log.d(LOG_TAG, "Tooltip already present, removing existing one")
            (overlayView as? ViewGroup)?.removeView(existingTooltip)
        }
            Log.d(LOG_TAG, "showToolTip")
            val (tooltip, text, icon) = createTooltip()
            toolTipLayout = tooltip
            bubbleText = text
            statusIcon = icon
            toolTipLayout.id = R.id.toolTipLayout
            (overlayView as? ViewGroup)?.addView(toolTipLayout)
            Log.d(LOG_TAG,"toolTip $toolTipLayout");




        // Check for status and update the text and icon
        if (isSharingOn) {
            bubbleText.text = getString(R.string.chat_message_on)
            statusIcon.setImageResource(R.drawable.status_icon_on)
        } else {
            bubbleText.text = getString(R.string.chat_message_off)
            statusIcon.setImageResource(R.drawable.status_icon_off)
        }
        toolTipLayout.alpha = 0f
        toolTipLayout.visibility = View.VISIBLE
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
            reverseAnimator.addListener(object : AnimatorListener {
                override fun onAnimationStart(animation: Animator) {}
                override fun onAnimationEnd(animation: Animator) {
                    (toolTipLayout.parent as? ViewGroup)?.removeView(toolTipLayout)
                    toolTipLayout.visibility = View.GONE
                }
                override fun onAnimationCancel(animation: Animator) {
                    (toolTipLayout.parent as? ViewGroup)?.removeView(toolTipLayout)
                    toolTipLayout.visibility = View.GONE
                }
                override fun onAnimationRepeat(animation: Animator) {}
            })

        }, 1200)

    }

    private fun hidePopUp() {
        if(!isPopUpShowing) return
        if (overlayView.parent != null) {
            (getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(
                overlayView
            )
            isPopUpShowing = false

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

        val startTime = endTime - 1000
        // Need to change compileSdk to 35 for query builder
        // val eventsQuery = UsageEventsQuery.Builder().setBeginTimeMillis(startTime)
        //    .setEndTimeMillis(endTime).build()
        // val events = usageStatsManager.queryEvents(eventsQuery)
        val events = usageStatsManager.queryEvents(startTime, endTime)
        val usageEvent = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(usageEvent)
            if(usageEvent.packageName == packageName){
                Log.d(LOG_TAG,"Event type ${usageEvent.eventType}")
                if(usageEvent.eventType == 1){
                    Log.d(
                                LOG_TAG,
                                "CAMERA OPEN DETECTED"
                            )
                            showPopUp()
                }else if(usageEvent.eventType == 2){
                    Log.d(
                                LOG_TAG,
                                "CAMERA CLOSE DETECTED"
                            )

                            hidePopUp()
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

        return notifBuilder.build()
    }


}