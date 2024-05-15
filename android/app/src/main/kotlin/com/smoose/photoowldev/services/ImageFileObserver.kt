package com.smoose.photoowldev.services
import android.content.Context
import android.os.Environment
import java.io.File
import android.os.FileObserver
import android.util.Log
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Data
import com.smoose.photoowldev.AppState

class ImageFileObserver (private val context: Context) : FileObserver("/storage/emulated/0/DCIM/Camera") {
    companion object {
        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
                "com.smoose.photoowldev.addImageToSqliteTask"
    }
        override fun startWatching(){
        Log.d("mainActivity debug","started file obervation")
        super.startWatching()
    }

    override fun stopWatching(){
        Log.d("mainActivity debug","stopped file obervation")
        super.stopWatching()
    }
    override fun onEvent(event: Int, path: String?){
        Log.d("mainActivity debug","event $event detected on $path")

        if(event == 128){
           val actual_path="/storage/emulated/0/DCIM/Camera/"+path
            Log.d("mainActivity debug","found new file in path -> "+actual_path)
            val data = Data.Builder()
                    .putString("path", actual_path.toString())
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
}