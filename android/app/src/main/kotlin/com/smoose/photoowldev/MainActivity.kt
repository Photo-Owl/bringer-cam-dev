package com.smoose.photoowldev

import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var isInForeground = false

    override fun onPause() {
        super.onPause()
        isInForeground = false
    }

    override fun onResume() {
        super.onResume()
        isInForeground = true
        startBackgroundService()
    }

    fun startBackgroundService() {
        if (! AutoUploadService.isInitialized() && isInForeground) {
            startService(Intent(this, AutoUploadService::class.java))
        }
    }
}
