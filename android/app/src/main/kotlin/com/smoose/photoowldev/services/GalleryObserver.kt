package com.smoose.photoowldev.services

import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

internal class GalleryObserver(private val context: Context) {
    companion object {
        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
            "com.smoose.photoowldev.addImageToSqliteTask"

        @JvmStatic
        // TODO: My user ID, need to get it from Firebase somehow
        // or this code should be moved to flutter and called via a methodchannel
        private val USER_ID = "29HbAeKsDifW6XrsrEDnLVxzjLI2"
    }

    private val observer =
        object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                if (selfChange) return
                val data = Data.Builder()
                    // TODO: Need to resolve this to actual image link
                    .putString("path", uri.toString())
                    .putString("owner", USER_ID)
                    .build()
                val addImageTask =
                    OneTimeWorkRequestBuilder<AddImageToSqliteWorker>()
                        .setInputData(data)
                        .build()
                WorkManager.getInstance(context).beginUniqueWork(
                    ADD_IMAGE_TO_SQLITE,
                    ExistingWorkPolicy.REPLACE,
                    addImageTask,
                ).enqueue()
            }
        }

    fun attach() {
        context.contentResolver.registerContentObserver(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            true,
            observer
        )
    }

    fun detach() {
        context.contentResolver.unregisterContentObserver(observer)
    }
}