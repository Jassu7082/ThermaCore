package com.thermacore.thermacore

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import java.io.File

class ThermalChannel(private val context: Context) {

    companion object {
        const val CHANNEL_NAME = "com.thermacore.android/thermal"
    }

    /**
     * Discover all available thermal zones on this device.
     * Returns a list of maps: [{"id": 0, "name": "cpu0", "path": "/sys/class/thermal/thermal_zone0"}]
     */
    fun discoverZones(): List<Map<String, Any>> {
        val thermalDir = File("/sys/class/thermal")
        if (!thermalDir.exists() || !thermalDir.isDirectory) return emptyList()

        return thermalDir.listFiles()
            ?.filter { it.name.startsWith("thermal_zone") }
            ?.sortedBy { it.name.removePrefix("thermal_zone").toIntOrNull() ?: 99 }
            ?.mapNotNull { zoneDir ->
                val idStr = zoneDir.name.removePrefix("thermal_zone")
                val id = idStr.toIntOrNull() ?: return@mapNotNull null
                val typeName = readFileOrNull(File(zoneDir, "type")) ?: "zone$id"
                mapOf(
                    "id" to id,
                    "name" to typeName,
                    "path" to zoneDir.absolutePath
                )
            } ?: emptyList()
    }

    /**
     * Read current temperatures for ALL thermal zones.
     * Returns: {"cpu0": 42500, "battery": 28000, ...}  (raw millidegrees)
     */
    fun readAllTemperatures(): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        val thermalDir = File("/sys/class/thermal")

        thermalDir.listFiles()
            ?.filter { it.name.startsWith("thermal_zone") }
            ?.forEach { zoneDir ->
                val typeName = readFileOrNull(File(zoneDir, "type")) ?: return@forEach
                val rawTemp = readFileOrNull(File(zoneDir, "temp"))?.toLongOrNull()
                if (rawTemp != null) {
                    result[typeName] = rawTemp
                }
            }

        // Always include battery temperature via BatteryManager API
        result["battery_bm"] = getBatteryTemperature()

        // Read cooling device states (throttle detection)
        result["_throttling"] = readThrottleState()

        return result
    }

    /**
     * Read a single zone by its sysfs path for quick polling.
     */
    fun readZoneTemperature(path: String): Long? {
        val tempFile = File(path, "temp")
        return readFileOrNull(tempFile)?.toLongOrNull()
    }

    /**
     * Get battery temperature from BatteryManager (tenths of degrees C).
     */
    fun getBatteryTemperature(): Int {
        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val intent = context.registerReceiver(null, filter)
        return intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
    }

    /**
     * Check if any cooling device is throttling.
     * Returns 1 if throttling detected, 0 if not.
     */
    private fun readThrottleState(): Int {
        val thermalDir = File("/sys/class/thermal")
        val anyThrottling = thermalDir.listFiles()
            ?.filter { it.name.startsWith("cooling_device") }
            ?.any { device ->
                val curState = readFileOrNull(File(device, "cur_state"))?.toLongOrNull() ?: 0L
                curState > 0L
            } ?: false
        return if (anyThrottling) 1 else 0
    }

    private fun readFileOrNull(file: File): String? {
        return try {
            if (file.exists() && file.canRead()) file.readText().trim() else null
        } catch (e: Exception) {
            null
        }
    }
}
