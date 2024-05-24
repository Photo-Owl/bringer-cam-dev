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
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.InputStream
import java.lang.Thread

//TODO: Delete the entire class and its usage
internal class GalleryObserver(private val context: Context) {
    companion object {
        @JvmStatic
        private val ADD_IMAGE_TO_SQLITE =
            "com.smoose.photoowldev.addImageToSqliteTask"
    }
    private var lastCalledURI:String? = null;

    private val observer =
        object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                if (selfChange) return
                if(lastCalledURI!=null && lastCalledURI == uri.toString()) return
                //TODO: change uri to actual file path
                Log.d("mainActivity debug","starting observer for the uri"+uri.toString())
                var path :String?="sleep";
                while (path=="sleep"){
                    path = convertURIToPath(uri,context,1)
                    Thread.sleep(500)
                }
                lastCalledURI = uri.toString()
                if(path==null) return
                Log.d("mainActivity debug","Path added to sql"+path.toString())
                val data = Data.Builder()
                    .putString("path", path.toString())
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
    private fun getExtensionFromUri(uri: Uri, context: Context): String {
        // Attempt to get the file extension from the Uri
        // This is a simplified example and might not work for all file types
        val mimeType = context.contentResolver.getType(uri)
        return when (mimeType) {
            "image/jpeg" -> ".jpg"
            "image/png" -> ".png"
            else -> ".jpg" // Fallback to a generic image file extension
        }
    }
    private fun convertURIToPath(uri: Uri?,context: Context, retryIndex: Int): String?{
        Log.d("mainActivity debug","converUTIToPath called for ${uri.toString()}")
        try {
            if (uri!=null){
                Log.d("mainActivity debug","converUTIToPath uri not null")
                val extension = getExtensionFromUri(uri, context)
                // Open an InputStream for the Uri
                val inputStream: InputStream? = context.contentResolver.openInputStream(uri)
                if (inputStream!= null) {
                    Log.d("mainActivity debug","converUTIToPath input stream not null not null")
                    // Convert the InputStream to a file path
                    val tempFile = File.createTempFile("temp", extension, context.cacheDir)
                    inputStream.use { input ->
                        tempFile.outputStream().use { output ->
                            input.copyTo(output)
                        }
                    }
                    Log.d("mainActivity debug","converUTIToPath uri returning abosulte path ${tempFile.absolutePath}")
                    return tempFile.absolutePath
                }
            }
        }catch (e:IllegalStateException){
            Log.d("mainActivity debug convertURIToPath","illegalSateException received waiting for 1sec...")
            return "sleep";
        }
    return null;
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