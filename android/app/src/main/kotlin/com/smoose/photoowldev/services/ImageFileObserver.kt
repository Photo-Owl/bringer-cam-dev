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
import android.content.SharedPreferences

class ImageFileObserver (private val context: Context) : FileObserver("/storage/emulated/0/DCIM/Camera") {
    private lateinit var sharedPrefs: SharedPreferences
    init {
        sharedPrefs = context.getSharedPreferences(
                "bringer_shared_preferences",
                Context.MODE_PRIVATE
        )
    }

    companion object {
        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
                "com.smoose.photoowldev.addImageToSqliteTask"
    }
    override fun startWatching(){
        sharedPrefs.edit().putBoolean("sharing_status", true).apply()
        Log.d("mainActivity debug","started file obervation")
        super.startWatching()
    }

    override fun stopWatching(){
        sharedPrefs.edit().putBoolean("sharing_status", false).apply()
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