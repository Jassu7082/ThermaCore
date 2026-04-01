package com.thermacore.thermacore

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.os.Build
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.*

class ThermalForegroundService : Service() {

    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private lateinit var thermalChannel: ThermalChannel
    private var pollingIntervalMs: Long = 2000L

    companion object {
        const val CHANNEL_ID = "thermacore_monitor"
        const val NOTIFICATION_ID = 1001
        const val ACTION_STOP = "com.thermacore.STOP_SERVICE"
    }

    override fun onCreate() {
        super.onCreate()
        thermalChannel = ThermalChannel(applicationContext)
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        pollingIntervalMs = intent?.getLongExtra("interval_ms", 2000L) ?: 2000L

        startForeground(NOTIFICATION_ID, buildNotification("Monitoring..."))

        serviceScope.launch {
            while (isActive) {
                try {
                    val temps = thermalChannel.readAllTemperatures()
                    val cpuTemp = temps.entries
                        .firstOrNull { it.key.contains("cpu", ignoreCase = true) }
                        ?.value as? Long

                    val displayTemp = cpuTemp?.let { "${it / 1000.0}°C" } ?: "--"
                    updateNotification("CPU: $displayTemp")

                    // Notify widget to update
                    sendBroadcast(Intent("com.thermacore.WIDGET_UPDATE").apply {
                        putExtra("temps", temps.toString())
                    })
                } catch (e: Exception) { /* continue monitoring */ }

                delay(pollingIntervalMs)
            }
        }

        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "ThermaCore Monitor",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Real-time temperature monitoring"
                setShowBadge(false)
            }
            getSystemService(NotificationManager::class.java)
                ?.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(text: String): Notification {
        val stopIntent = PendingIntent.getService(
            this, 0,
            Intent(this, ThermalForegroundService::class.java).apply {
                action = ACTION_STOP
            },
            PendingIntent.FLAG_IMMUTABLE
        )

        val openAppIntent = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("ThermaCore")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setOngoing(true)
            .setSilent(true)
            .setContentIntent(openAppIntent)
            .addAction(0, "Stop", stopIntent)
            .build()
    }

    private fun updateNotification(text: String) {
        getSystemService(NotificationManager::class.java)
            ?.notify(NOTIFICATION_ID, buildNotification(text))
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
    }
}
