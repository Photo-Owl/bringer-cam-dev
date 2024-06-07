package com.smoose.photoowldev

import android.Manifest
import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.MediaStore
import android.provider.Settings
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

        @JvmStatic
        private val SHARE_CHANNEL_ID = "com.smoose.photoowldev/sharePhotos"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        handleSharedPhotos(flutterEngine)
        autoUploadChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_ID
        )
            .apply {
                setMethodCallHandler { methodCall, result ->
                    when (methodCall.method) {
                        "setSignInStatus" -> setSignInStatus(
                            methodCall.argument(
                                "userId"
                            ), result
                        )

                        "checkForPermissions" -> result.success(
                            checkForPermissions()
                        )

                        "requestExternalStoragePermission" -> result.success(
                            requestExternalStoragePermission()
                        )

                        "requestUsageStatsAccess" -> result.success(
                            requestUsageStatsAccess()
                        )

                        "requestOverlayPermission" -> result.success(
                            requestOverlayPermission()
                        )

                        "requestIgnoreBatteryOptimization" -> result.success(
                            requestIgnoreBatteryOptimization()
                        )

                        "openCamera" -> {
                            startActivity(Intent(MediaStore.INTENT_ACTION_STILL_IMAGE_CAMERA))
                            result.success("")
                        }

                        else -> result.notImplemented()
                    }
                }
            }
        MethodChannelHolder.methodChannel = autoUploadChannel

    }

    private fun handleSharedPhotos(flutterEngine: FlutterEngine) {
        var photosList: List<String> = listOf()
        when (intent.action) {
            Intent.ACTION_SEND -> {
                intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let {
                    photosList = listOf(it.toString())
                }
            }

            Intent.ACTION_SEND_MULTIPLE -> {
                intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
                    ?.map { it.toString() }
                    ?.let { photosList = it }
            }
        }

        if (photosList.isNotEmpty()) {
            val channel = MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                SHARE_CHANNEL_ID
            )
            channel.invokeMethod("sharePhotos", photosList)
        }
    }

//    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
//        autoUploadChannel.setMethodCallHandler(null)
//        super.cleanUpFlutterEngine(flutterEngine)
//    }

    private fun checkForPermissions(): Boolean {
        return isBatteryOptimizationIgnored() && checkForExternalStoragePermission() && checkForUsageStatsAccess() && canDrawOverlays()
    }

    private fun isBatteryOptimizationIgnored(): Boolean {
        val powerManager =
            getSystemService(Context.POWER_SERVICE) as PowerManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            powerManager.isIgnoringBatteryOptimizations(packageName)
        } else true
    }

    private fun requestIgnoreBatteryOptimization(): Boolean {
        var isGranted = isBatteryOptimizationIgnored()
        if (!isGranted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, 3)
            isGranted = isBatteryOptimizationIgnored()
        }
        return isGranted
    }

    private fun checkForExternalStoragePermission() =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.READ_MEDIA_IMAGES
            ) == PackageManager.PERMISSION_GRANTED
        else
            ActivityCompat.checkSelfPermission(
                context, Manifest.permission.READ_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED

    private fun requestExternalStoragePermission(): Boolean {
        var isGranted = checkForExternalStoragePermission()
        if (!isGranted) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                ActivityCompat.requestPermissions(
                    activity,
                    arrayOf(Manifest.permission.READ_MEDIA_IMAGES),
                    123
                )
            } else {
                ActivityCompat.requestPermissions(
                    activity,
                    arrayOf(
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ),
                    123
                )
            }
            isGranted = checkForExternalStoragePermission()
        }
        return isGranted
    }

    private fun checkForUsageStatsAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val pid = android.os.Process.myUid()
        val mode =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS, pid, packageName
                )
            else
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS, pid, packageName
                )

        return if (mode == AppOpsManager.MODE_DEFAULT && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            context.checkCallingOrSelfPermission(Manifest.permission.PACKAGE_USAGE_STATS) == PackageManager.PERMISSION_GRANTED
        } else {
            mode == AppOpsManager.MODE_ALLOWED
        }
    }

    private fun requestUsageStatsAccess(): Boolean {
        Log.d("mainActivity debug", "Checking usage stats permission...")
        var granted = checkForUsageStatsAccess()
        Log.d("mainActivity debug", "permission $granted")
        if (!granted) {
            Log.d(
                "mainActivity debug",
                "Permission usage stats not granted. Requesting permission..."
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val intent = Intent(
                    Settings.ACTION_USAGE_ACCESS_SETTINGS,
                    Uri.parse("package:$packageName")
                )
                startActivityForResult(intent, 1)
            }
            granted = checkForUsageStatsAccess()
        } else {
            Log.d("mainActivity debug", "Permission already granted.")
        }
        return granted
    }

    private fun canDrawOverlays() =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            Settings.canDrawOverlays(this)
        else
            true

    private fun requestOverlayPermission(): Boolean {
        var granted = canDrawOverlays()
        if (!granted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, 1)
            granted = canDrawOverlays()
        }
        return granted
    }

    private fun initializeService(
        isSignedIn: Boolean,
        result: MethodChannel.Result
    ) {
        try {
            val intent = Intent(this, AutoUploadService::class.java)
            intent.putExtra(
                AutoUploadService.SERVICE_STATE_EXTRA,
                if (isSignedIn) ServiceState.INIT_SIGNED_IN else ServiceState.INIT
            )
            val canSend =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.POST_NOTIFICATIONS
                    ) == PackageManager.PERMISSION_GRANTED
                else true
            if (canSend) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(intent)
                } else {
                    startService(intent)
                }
            }
            result.success("")
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
