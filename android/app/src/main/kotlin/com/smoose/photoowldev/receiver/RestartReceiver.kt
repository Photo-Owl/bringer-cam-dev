package com.smoose.photoowldev.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat
import com.smoose.photoowldev.services.AutoUploadService

class RestartReceiver : BroadcastReceiver() {
    companion object {
        @JvmStatic
        private val LOG_TAG = "bringer/RestartReceiver"

        @JvmStatic
        private val ACTION_RESTART =
            "com.smoose.photoowldev.action.RESTART_SERVICE"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_RESTART) {
            Log.d(LOG_TAG, "Restarting AutoUploadService if dead")
            ContextCompat.startForegroundService(
                context,
                Intent(context, AutoUploadService::class.java)
            )
        }
    }
}
