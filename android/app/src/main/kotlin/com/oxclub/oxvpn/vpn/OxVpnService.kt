package com.oxclub.oxvpn.vpn

import android.app.Notification
import android.content.Intent
import android.net.VpnService

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
        startForeground(NOTIF_ID, buildNotification())
    }

    private fun stopTunnel() {
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun buildNotification(): Notification {
        return Notification.Builder(this, "oxvpn")
            .setContentTitle("OxVPN")
            .setContentText("Connected")
            .setSmallIcon(android.R.drawable.stat_sys_vpn_ic)
            .build()
    }

    companion object {
        const val ACTION_CONNECT = "com.oxclub.oxvpn.CONNECT"
        const val ACTION_DISCONNECT = "com.oxclub.oxvpn.DISCONNECT"
        const val NOTIF_ID = 1001
    }
}
