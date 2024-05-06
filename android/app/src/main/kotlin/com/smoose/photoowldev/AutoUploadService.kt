package com.smoose.photoowldev

import android.Manifest
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.room.Room
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.Calendar

class AddImageToSqliteWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    companion object {
        @JvmStatic
        private val LOG_TAG = "bringer/addImageWorker"

        @JvmStatic
        private val DB_NAME = "bringerCam"
    }

    override fun doWork(): Result {
        val imagePath = inputData.getString("path")
        val imageOwner = inputData.getString("owner")
        if (imagePath == null || imageOwner == null) {
            Log.d(LOG_TAG, "Path or owner missing: Cannot add to DB")
            return Result.success()
        }
        try {
            val db = Room.databaseBuilder(
                applicationContext,
                ImagesDB::class.java,
                DB_NAME
            ).build()
            val imagesDao = db.imagesDao()
            imagesDao.insertAll(
                Images(
                    path = imagePath,
                    owner = imageOwner,
                    unixTimestamp = Calendar.getInstance().timeInMillis,
                    isUploaded = 0,
                    isUploading = 0,
                )
            )
            return Result.success()
        } catch (e: Error) {
            Log.e(LOG_TAG, "Unexpected error", e)
            return Result.failure()
        }
    }
}

class AutoUploadService : Service() {
    private val observer =
        object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                sendDebugNotification(
                    title = "New image taken",
                    desc = uri.toString()
                )
                val data = Data.Builder()
                    .putString("path", uri.toString())
                    .putString("owner", USER_ID)
                    .build()
                val addImageTask = OneTimeWorkRequestBuilder<AddImageToSqliteWorker>()
                    .setInputData(data)
                    .build()
                WorkManager.getInstance(applicationContext).beginUniqueWork(
                    ADD_IMAGE_TO_SQLITE,
                    ExistingWorkPolicy.APPEND,
                    addImageTask,
                ).enqueue()
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
        private val CHANNEL_ID = "com.smoose.photoowldev.autoUploadDebug"

        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
            "com.smoose.photoowldev.addImageToSqliteTask"

        @JvmStatic
        // TODO: My user ID, need to get it from Firebase somehow
        // or this code should be moved to flutter and called via a methodchannel
        private val USER_ID = "29HbAeKsDifW6XrsrEDnLVxzjLI2"
    }

    override fun onCreate() {
        super.onCreate()
        isInitialized = true
    }

    override fun onDestroy() {
        isInitialized = false
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
        Log.d(LOG_TAG, "service started")
        sendDebugNotification(
            "Auto upload service",
            "Auto upload service is running."
        )
        contentResolver.registerContentObserver(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            true,
            observer
        )
        val action = NotificationCompat.Action(
            R.drawable.ic_mono, "TURN OFF", PendingIntent.getService(
                this, 1, Intent(Settings.ACTION_ADD_ACCOUNT),
                PendingIntent.FLAG_IMMUTABLE
            )
        )
        val notif = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Auto upload service")
            .setContentText("Auto upload service is running in foreground.")
            .setSmallIcon(R.drawable.ic_mono)
            .addAction(action)
            .setAutoCancel(false)
            .build()
        startForeground(1, notif)
        return START_STICKY
    }

    private fun sendDebugNotification(title: String, desc: String) {
        val notif = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(desc)
            .setSmallIcon(R.drawable.ic_mono)
            .setAutoCancel(false)
            .build()
        val notifManager = NotificationManagerCompat.from(applicationContext)
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // rn having code in flutter side for notifications

            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        val notifChannel = NotificationChannelCompat.Builder(
            CHANNEL_ID,
            NotificationManagerCompat.IMPORTANCE_HIGH
        ).setName("Auto upload debug channel").build()
        try {
            notifManager.createNotificationChannel(notifChannel)
            notifManager.notify(desc.hashCode(), notif)
        } catch (e: Error) {
            Log.e(LOG_TAG, e.toString())
        }
    }
}