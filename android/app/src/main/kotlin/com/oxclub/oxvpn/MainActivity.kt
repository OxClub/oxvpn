package com.oxclub.oxvpn

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        // Register oxvpn/control MethodChannel and oxvpn/state EventChannel here.
    }
}
