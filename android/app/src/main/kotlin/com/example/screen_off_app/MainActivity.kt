package com.example.screen_off_app

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.screen_off_app.MyAdminReceiver

class MainActivity : FlutterActivity() {
    private val CHANNEL = "screen_off_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "turnOffScreen" -> {
                    val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val compName = ComponentName(this, MyAdminReceiver::class.java)
                    if (dpm.isAdminActive(compName)) {
                        dpm.lockNow()
                        result.success(null)
                    } else {
                        result.error("NOT_ADMIN", "Device admin not active", null)
                    }
                }

                "simulateScreenOff" -> {
                    val intent = Intent(this, OffScreenActivity::class.java)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
