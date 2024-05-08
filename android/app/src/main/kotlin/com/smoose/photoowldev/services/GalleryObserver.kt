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
import com.smoose.photoowldev.AppState

internal class GalleryObserver(private val context: Context) {
    companion object {
        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
            "com.smoose.photoowldev.addImageToSqliteTask"
    }

    private val observer =
        object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                if (selfChange) return
                val data = Data.Builder()
                    .putString("path", uri.toString())
                    .putString("owner", AppState.authUser)
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