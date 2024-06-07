package com.smoose.photoowldev

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.core.content.IntentCompat

class ShareActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
    }
}