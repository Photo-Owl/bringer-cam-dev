package com.smoose.photoowldev.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat
import com.smoose.photoowldev.services.AutoUploadService

class BootCompleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action.equals(Intent.ACTION_BOOT_COMPLETED)) {
            Log.d("bringer/receiver", "Auto started service on boot.")
            ContextCompat.startForegroundService(
                context,
                Intent(context, AutoUploadService::class.java)
            )
        }
    }
}