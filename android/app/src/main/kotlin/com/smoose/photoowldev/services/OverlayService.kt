package com.smoose.photoowldev.services

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.view.WindowManager
import com.smoose.photoowldev.R
import android.view.View
import android.content.Context
import android.content.SharedPreferences
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.util.Log
import android.view.MotionEvent
import android.widget.ImageView




class OverlayService : Service() {
    private lateinit var overlayView: View
    private var isSharingOn = true
    private lateinit var sharedPrefs: SharedPreferences

    private val prefsListener =
        SharedPreferences.OnSharedPreferenceChangeListener { _, key ->
            if (key == "sharing_status"){
                getPersistedShareStatus()
                val imageView = overlayView.findViewById<ImageView>(R.id.imageView)
                if (isSharingOn){
                    imageView.setImageResource(R.drawable.bringer_logo)
                }else{
                    imageView.setImageResource(R.drawable.bringer_logo_bandw)
                }
            }

        }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
    private fun overlayOnClick(){
        Log.d("mainActivity debug overlay","overlay click detected")
        val imageView = overlayView.findViewById<ImageView>(R.id.imageView)
        if (isSharingOn){


            isSharingOn = false
        }else{


            isSharingOn = true
        }
    }

    private fun getPersistedShareStatus() {
        isSharingOn = sharedPrefs.getBoolean("sharing_status", true)
    }

    override fun onCreate() {
        super.onCreate()
        overlayView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
        overlayView.setOnTouchListener { v, event ->
            if (event.action == MotionEvent.ACTION_DOWN) {
                overlayOnClick()
                true
            } else {
                false
            }
        }
        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        sharedPrefs = getSharedPreferences(
            "bringer_shared_preferences",
            Context.MODE_PRIVATE
        )
        getPersistedShareStatus()
        sharedPrefs.registerOnSharedPreferenceChangeListener(prefsListener)
        val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.START
        windowManager.addView(overlayView, params)
    }
    fun stopOverlayService() {
        stopSelf()
    }

    override fun onDestroy() {
        sharedPrefs.unregisterOnSharedPreferenceChangeListener(prefsListener)
        if (overlayView!= null) {
            (getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(overlayView)
        }
        super.onDestroy()
    }
}
