package com.example.screen_off_app

import android.app.Activity
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager

class OffScreenActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Make it black and fullscreen
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        )

        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_FULLSCREEN or
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
        )

        // Dim screen to 0 brightness
        val layoutParams = window.attributes
        layoutParams.screenBrightness = 0f
        window.attributes = layoutParams
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        finish() // Tap to exit
        return super.onTouchEvent(event)
    }
}
