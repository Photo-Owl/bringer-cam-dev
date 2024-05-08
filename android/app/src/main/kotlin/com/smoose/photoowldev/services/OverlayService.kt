package com.smoose.photoowldev.services

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.view.WindowManager
import com.smoose.photoowldev.R
import android.view.View
import android.content.Context
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.util.Log
import android.view.MotionEvent
import android.widget.ImageView




class OverlayService : Service() {

    private lateinit var overlayView: View
    //TODO: on create service set the value for isSharingOn
    private var isSharingOn = true
    override fun onBind(intent: Intent): IBinder? {
        return null
    }
    private fun overlayOnClick(){
        Log.d("mainActivity debug overlay","overlay click detected")
        val imageView = overlayView.findViewById<ImageView>(R.id.imageView)
        if (isSharingOn){
            imageView.setImageResource(R.drawable.bringer_logo_bandw)
            isSharingOn = false
        }else{
            imageView.setImageResource(R.drawable.bringer_logo)
            isSharingOn = true
        }


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
        super.onDestroy()
        if (overlayView!= null) {
            (getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(overlayView)
        }
    }
}
