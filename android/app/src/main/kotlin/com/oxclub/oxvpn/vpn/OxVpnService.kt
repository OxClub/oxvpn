package com.oxclub.oxvpn.vpn

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.VpnService
import android.os.Build
import com.oxclub.oxvpn.R

class OxVpnService : VpnService() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_CONNECT -> startTunnel()
            ACTION_DISCONNECT -> stopTunnel()
        }
        return START_STICKY
    }

    private fun startTunnel() {
        val builder = Builder()
            .setSession("OxVPN")
            .addAddress("10.7.0.2", 32)
            .addDnsServer("1.1.1.1")
            .addRoute("0.0.0.0", 0)
        builder.establish()
        createChannel()
        startForeground(NOTIF_ID, buildNotification())
    }

    private fun stopTunnel() {
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val mgr = getSystemService(NotificationManager::class.java)
            if (mgr.getNotificationChannel(CHANNEL_ID) == null) {
                val ch = NotificationChannel(
                    CHANNEL_ID,
                    "OxVPN",
                    NotificationManager.IMPORTANCE_LOW
                )
                mgr.createNotificationChannel(ch)
            }
        }
    }

    private fun buildNotification(): Notification {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setContentTitle("OxVPN")
            .setContentText("Connected")
            .setSmallIcon(R.drawable.ic_vpn_notification)
            .setOngoing(true)
            .build()
    }

    companion object {
        const val ACTION_CONNECT = "com.oxclub.oxvpn.CONNECT"
        const val ACTION_DISCONNECT = "com.oxclub.oxvpn.DISCONNECT"
        const val NOTIF_ID = 1001
        const val CHANNEL_ID = "oxvpn"
    }
}
