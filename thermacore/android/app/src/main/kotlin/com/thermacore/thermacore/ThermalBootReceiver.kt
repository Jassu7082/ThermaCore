package com.thermacore.thermacore

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class ThermalBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            // Auto-start foreground monitoring service on boot
            val serviceIntent = Intent(context, ThermalForegroundService::class.java)
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}
