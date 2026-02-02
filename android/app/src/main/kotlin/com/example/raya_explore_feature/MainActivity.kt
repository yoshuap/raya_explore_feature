package com.example.raya_explore_feature

import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "battery_bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryStatus") {
                result.success(getBatteryStatus())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryStatus(): HashMap<String, Any> {
        val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatus = registerReceiver(null, intentFilter)

        val status = batteryStatus?.getIntExtra(
            BatteryManager.EXTRA_STATUS, -1
        ) ?: -1

        val plugged = batteryStatus?.getIntExtra(
            BatteryManager.EXTRA_PLUGGED, -1
        ) ?: -1

        val level = batteryStatus?.getIntExtra(
            BatteryManager.EXTRA_LEVEL, -1
        ) ?: -1

        val health = batteryStatus?.getIntExtra(
            BatteryManager.EXTRA_HEALTH, -1
        ) ?: -1

        val isPlugged = plugged > 0

        // In Android, BATTERY_STATUS_NOT_CHARGING or BATTERY_STATUS_DISCHARGING 
        // while plugged in indicates "connected not charging"
        val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                         status == BatteryManager.BATTERY_STATUS_FULL

        val isConnectedNotCharging = isPlugged && !isCharging

        val healthStatus = when (health) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Unspecified Failure"
            BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
            else -> "Unknown"
        }

        return hashMapOf(
            "isCharging" to isCharging,
            "isPlugged" to isPlugged,
            "isConnectedNotCharging" to isConnectedNotCharging,
            "batteryLevel" to level,
            "batteryHealth" to healthStatus
        )
    }
}
