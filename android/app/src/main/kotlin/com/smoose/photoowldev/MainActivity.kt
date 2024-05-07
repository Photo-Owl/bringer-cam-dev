package com.smoose.photoowldev

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import com.smoose.photoowldev.services.AutoUploadService
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

    private fun startBackgroundService() {
        val canSend = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        else true
        if (! AutoUploadService.isInitialized() && isInForeground && canSend) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(Intent(this, AutoUploadService::class.java))
            } else {
                startService(Intent(this, AutoUploadService::class.java))
            }
        }
    }
}
