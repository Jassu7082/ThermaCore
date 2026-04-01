package com.thermacore.thermacore

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var thermalChannel: ThermalChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        thermalChannel = ThermalChannel(applicationContext)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ThermalChannel.CHANNEL_NAME
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "discoverZones" -> {
                    try {
                        result.success(thermalChannel.discoverZones())
                    } catch (e: Exception) {
                        result.error("DISCOVER_FAIL", e.message, null)
                    }
                }
                "readAllTemperatures" -> {
                    try {
                        result.success(thermalChannel.readAllTemperatures())
                    } catch (e: Exception) {
                        result.error("READ_FAIL", e.message, null)
                    }
                }
                "readZoneTemperature" -> {
                    val path = call.argument<String>("path")
                    if (path == null) {
                        result.error("BAD_ARGS", "path argument required", null)
                    } else {
                        val temp = thermalChannel.readZoneTemperature(path)
                        result.success(temp)
                    }
                }
                "getBatteryTemperature" -> {
                    result.success(thermalChannel.getBatteryTemperature())
                }
                else -> result.notImplemented()
            }
        }
    }
}
