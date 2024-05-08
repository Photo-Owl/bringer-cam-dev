package com.smoose.photoowldev.services

import android.Manifest
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.smoose.photoowldev.R

internal class ServiceState {
    companion object {
        @JvmStatic val INIT = 0
        @JvmStatic val START_SHARING = 1
        @JvmStatic val STOP_SHARING = 2
    }
}

class AutoUploadService : Service() {
    private var observer: GalleryObserver? = null
    private var serviceState: Int = 0

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
            ServiceState.INIT -> initializeService()
            ServiceState.START_SHARING -> startSharing()
            ServiceState.STOP_SHARING -> stopSharing()
        }
        return START_STICKY
    }

    private fun initializeService() {
        isInitialized = true
        observer = GalleryObserver(applicationContext).apply { attach() }

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

        serviceState = ServiceState.START_SHARING
        startForeground(SERVICE_ID, createPersistentNotification())
    }

    private fun startSharing() {
        if (!isInitialized) {
            initializeService()
            return
        }
        serviceState = ServiceState.START_SHARING
        observer = GalleryObserver(applicationContext).apply { attach() }
        updatePersistentNotification()
    }

    private fun stopSharing() {
        serviceState = ServiceState.STOP_SHARING
        observer?.apply { detach() }?.let { observer = null }
        updatePersistentNotification()
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
        val contentText = getString(when (serviceState) {
            ServiceState.START_SHARING -> R.string.auto_upload_notif_body_on
            ServiceState.STOP_SHARING -> R.string.auto_upload_notif_body_off
            else -> R.string.auto_upload_notif_body_inactive
        })

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