package com.smoose.photoowldev

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import com.smoose.photoowldev.services.AutoUploadService
import com.smoose.photoowldev.services.ServiceState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var autoUploadChannel: MethodChannel

    companion object {
        @JvmStatic
        private val LOG_TAG = "bringer/MainActivity"

        @JvmStatic
        private val CHANNEL_ID = "com.smoose.photoowldev/autoUpload"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        autoUploadChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_ID
        )
            .apply {
                setMethodCallHandler { methodCall, result ->
                    when (methodCall.method) {
                        "setSignInStatus" -> setSignInStatus(methodCall.argument("userId"), result)
                        else -> result.notImplemented()
                    }
                }
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        autoUploadChannel.setMethodCallHandler(null)
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun initializeService(
        isSignedIn: Boolean,
        result: MethodChannel.Result
    ) {
        try {
            val intent = Intent(this, AutoUploadService::class.java)
            intent.putExtra(
                AutoUploadService.SERVICE_STATE_EXTRA,
                if (isSignedIn) ServiceState.INIT else ServiceState.START_SHARING
            )
            val canSend =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.POST_NOTIFICATIONS
                    ) == PackageManager.PERMISSION_GRANTED
                else true
            if (!AutoUploadService.isInitialized() && canSend) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(intent)
                } else {
                    startService(intent)
                }
            }
            result.success(null)
        } catch (e: Error) {
            Log.e(LOG_TAG, "Unexpected error.", e)
            result.error("ERROR", "Unexpected error", null)
        }
    }

    private fun setSignInStatus(userId: String?, result: MethodChannel.Result) {
        if (userId == null) {
            AppState.authUser = null
            initializeService(true, result)
        } else {
            AppState.authUser = userId
            initializeService(false, result)
        }
    }
}
