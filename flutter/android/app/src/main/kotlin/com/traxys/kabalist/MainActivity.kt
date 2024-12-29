package com.traxys.kabalist

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle

class MainActivity: FlutterActivity() {
	override fun onNewIntent(intent: Intent) {
			super.onNewIntent(intent)
			intent.data?.let {
				// Forward the deep link to Flutter
				intent.putExtra("flutter_deeplink", it.toString())
			}
		}
}
