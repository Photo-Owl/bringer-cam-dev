package com.smoose.photoowldev

import android.Manifest
import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Looper
import android.os.Handler
import android.os.PowerManager
import android.content.ContentResolver
import android.media.AudioAttributes
import android.media.AudioAttributes.Builder
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.smoose.photoowldev.R
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.IntentCompat
import com.smoose.photoowldev.services.AutoUploadService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

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
                        "checkForPermissions" -> result.success(
                            checkForPermissions()
                        )

                        "checkExternalStoragePermission" -> result.success(
                            checkForExternalStoragePermission()
                        )

                        "requestExternalStoragePermission" -> {
                            requestExternalStoragePermission()
                            checkPermissionWithTimeout(::checkForExternalStoragePermission, result)
                        }

                        "requestUsageStatsAccess" -> {
                            requestUsageStatsAccess()
                            checkPermissionWithTimeout(::checkForUsageStatsAccess, result)
                        }

                        "requestOverlayPermission" ->{
                            requestOverlayPermission()
                            checkPermissionWithTimeout(::canDrawOverlays, result)
                        }

                        "requestIgnoreBatteryOptimization" -> {
                        requestIgnoreBatteryOptimization()
                        checkPermissionWithTimeout(::isBatteryOptimizationIgnored, result)
                    }

                        "checkForContactsPermission" -> result.success(
                            checkForContactsPermission()
                        )

                        "requestContactsPermission" -> {
                            requestContactsPermission()
                            checkPermissionWithTimeout(::checkForContactsPermission, result)
                        }

                        "startService" -> {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                Log.d(LOG_TAG, "Starting service")
                                startForegroundService(Intent(applicationContext, AutoUploadService::class.java))
                            } else {
                                Log.d(LOG_TAG, "Starting service")
                                startService(Intent(applicationContext, AutoUploadService::class.java))
                            }
                            result.success("")
                        }

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
    private fun checkPermissionWithTimeout(permissionCheck: () -> Boolean, result: MethodChannel.Result) {
        val handler = Handler(Looper.getMainLooper())
        var elapsedTime = 0

        val runnable = object : Runnable {
            override fun run() {
                if (permissionCheck()) {
                    result.success(true)
                } else if (elapsedTime >= 120) {
                    result.success(null)
                } else {
                    elapsedTime++
                    handler.postDelayed(this, 1000)
                }
            }
        }

        handler.post(runnable)
    }

    private fun handleSharedPhotos(flutterEngine: FlutterEngine) {
        var photosList: List<String> = listOf()
        when (intent.action) {
            Intent.ACTION_SEND -> {
                IntentCompat.getParcelableExtra(
                    intent,
                    Intent.EXTRA_STREAM,
                    Uri::class.java
                )?.let {
                    photosList = listOf(it.toString())
                }
            }

            Intent.ACTION_SEND_MULTIPLE -> {
                IntentCompat.getParcelableArrayListExtra(
                    intent,
                    Intent.EXTRA_STREAM,
                    Uri::class.java
                )
                    ?.map { it.toString() }
                    ?.let { photosList = it }
            }
        }

        Log.d("bringer/sharePhotos", "photosList: ${photosList.isNotEmpty()} ${photosList.size}")

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

    private fun requestExternalStoragePermission() {
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

        }

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

    private fun requestUsageStatsAccess() {
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

        } else {
            Log.d("mainActivity debug", "Permission already granted.")
        }

    }

    private fun canDrawOverlays() =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            Settings.canDrawOverlays(this)
        else
            true

    private fun requestOverlayPermission() {
        var granted = canDrawOverlays()
        if (!granted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, 1)

        }

    }

    private fun checkForContactsPermission() : Boolean {
        return ActivityCompat.checkSelfPermission(
            context,
            Manifest.permission.READ_CONTACTS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestContactsPermission()  {
        var isGranted = checkForContactsPermission()
        if (!isGranted) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.READ_CONTACTS),
                123
            )

        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val audioAttributes: AudioAttributes = Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_ALARM)
                .build()
            val sound: Uri =
                Uri.parse((ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + context.getPackageName()).toString() + "/" + R.raw.custom_sound)
            val notifChannel = NotificationChannelCompat.Builder(
                "photo_found",
                NotificationManagerCompat.IMPORTANCE_MAX
            )
                .setName(getString(R.string.photo_found_channel_name)).setSound(sound, audioAttributes)
                .build()
            NotificationManagerCompat.from(applicationContext).createNotificationChannel(notifChannel)

        }
    }
}
