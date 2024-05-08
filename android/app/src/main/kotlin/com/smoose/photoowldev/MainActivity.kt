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
import android.app.AppOpsManager
import android.content.Context
import android.net.Uri
import android.provider.Settings

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
                        "checkForPermissions"-> checkForPermissions()
                        else -> result.notImplemented()
                    }
                }
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        autoUploadChannel.setMethodCallHandler(null)
        super.cleanUpFlutterEngine(flutterEngine)
    }
    private fun checkForPermissions(){
        checkPackageUsageStatsPermission()
        requestOverlayPermission()
    }
    private fun checkPackageUsageStatsPermission() {

        Log.d("mainActivity debug","Checking usage stats permission...")
//        val permission =ActivityCompat.checkSelfPermission(this, Manifest.permission.PACKAGE_USAGE_STATS);

        var granted = false
        val appOps: AppOpsManager = context
                .getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode: Int = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(), context.getPackageName())

        granted = if (mode == AppOpsManager.MODE_DEFAULT) {
            context.checkCallingOrSelfPermission(android.Manifest.permission.PACKAGE_USAGE_STATS) === PackageManager.PERMISSION_GRANTED
        } else {
            mode == AppOpsManager.MODE_ALLOWED
        }
        Log.d("mainActivity debug","permission $granted")
        if (!granted) {
            Log.d("mainActivity debug","Permission usage stats not granted. Requesting permission...")
            requestUsageStatsPermission()
        } else {
            Log.d("mainActivity debug","Permission already granted.")
            return;
        }
    }
    private fun requestUsageStatsPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS, Uri.parse("package:$packageName"))
            startActivityForResult(intent, 1)

        }
    }
    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
                startActivityForResult(intent, 1)
            }
        }
    }



    private fun initializeService(
        isSignedIn: Boolean,
        result: MethodChannel.Result
    ) {
        try {
            val intent = Intent(this, AutoUploadService::class.java)
            intent.putExtra(
                AutoUploadService.SERVICE_STATE_EXTRA,
                if (!isSignedIn) ServiceState.INIT else ServiceState.START_SHARING
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
            result.success("implememted")
        } catch (e: Error) {
            Log.e(LOG_TAG, "Unexpected error.", e)
            result.error("ERROR", "Unexpected error", null)
        }
    }

    private fun setSignInStatus(userId: String?, result: MethodChannel.Result) {
        if (userId == null) {
            AppState.authUser = null
            initializeService(false, result)
        } else {
            AppState.authUser = userId
            initializeService(true, result)
        }
    }
}
