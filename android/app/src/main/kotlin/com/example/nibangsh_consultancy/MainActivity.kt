
package com.example.nibangsh_consultancy

import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "secure_screen"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "enable" -> {
                    window.addFlags(
                        WindowManager.LayoutParams.FLAG_SECURE
                    )

                    Log.d(
                        "SecureScreen",
                        "================================"
                    )
                    Log.d(
                        "SecureScreen",
                        "FLAG_SECURE ENABLED"
                    )
                    Log.d(
                        "SecureScreen",
                        "FLAG VALUE: ${window.attributes.flags}"
                    )
                    Log.d(
                        "SecureScreen",
                        "================================"
                    )

                    result.success(true)
                }

                "disable" -> {
                    window.clearFlags(
                        WindowManager.LayoutParams.FLAG_SECURE
                    )

                    Log.d(
                        "SecureScreen",
                        "FLAG_SECURE DISABLED"
                    )

                    Log.d(
                        "SecureScreen",
                        "FLAG VALUE AFTER DISABLE: ${window.attributes.flags}"
                    )

                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

