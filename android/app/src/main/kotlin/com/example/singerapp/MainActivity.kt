package com.example.singerapp

import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/toast"

   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showToast") {
                val message = call.argument<String>("message")
                val length = call.argument<String>("length") ?: "short"
                val duration = if (length == "long") Toast.LENGTH_LONG else Toast.LENGTH_SHORT

                Toast.makeText(this, message, duration).show()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
