package com.smoose.photoowldev.services

import android.content.Context
import android.util.Log
import androidx.room.Room
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.smoose.photoowldev.db.Images
import com.smoose.photoowldev.db.ImagesDB
import java.util.Calendar
import com.smoose.photoowldev.MethodChannelHolder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.loader.FlutterLoader;


class AddImageToSqliteWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    companion object {
        @JvmStatic
        private val LOG_TAG = "bringer/addImageWorker"

        @JvmStatic
        private val DB_NAME = "bringer_cam.db"
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


            val images = imagesDao.lastAdded()
            Log.d(LOG_TAG, "inserted: ${images.path}")
            return Result.success()
        } catch (e: Error) {
            Log.e(LOG_TAG, "Unexpected error", e)
            return Result.failure()
        }
    }
}