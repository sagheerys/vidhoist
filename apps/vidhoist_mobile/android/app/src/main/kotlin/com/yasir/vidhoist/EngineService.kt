package com.yasir.vidhoist

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.content.ContextCompat
import java.util.concurrent.atomic.AtomicInteger

/**
 * The foreground service that keeps downloads going with the app out of
 * sight, and with it swiped away.
 *
 * Measured on the phone (2026-11-06): swiping the app from Recents disposes
 * the Flutter engine (audio_service lets its engine go when nothing plays),
 * so flutter_background's service, which belongs to the engine, went with it
 * and the running yt-dlp died mid-file. This service belongs to the process:
 * it runs while Dart asks for it (tasks queued or waiting for Wi-Fi) and,
 * whatever happens to Dart, while any yt-dlp run is going ([YtDlpBridge]).
 */
class EngineService : Service() {
    companion object {
        private const val TAG = "EngineService"
        private const val CHANNEL = "vidhoist_engine"
        private const val NOTICE_ID = 7301

        @Volatile
        private var wanted = false
        private val runs = AtomicInteger(0)

        @Volatile
        private var title = "Vidhoist"

        @Volatile
        private var text = ""

        /** Dart's side: on while any task is unfinished. */
        fun keepAlive(context: Context, on: Boolean, title: String?, text: String?) {
            wanted = on
            title?.let { this.title = it }
            text?.let { this.text = it }
            update(context)
        }

        fun runStarted(context: Context) {
            runs.incrementAndGet()
            update(context)
        }

        fun runEnded(context: Context) {
            runs.decrementAndGet()
            update(context)
        }

        private fun update(context: Context) {
            val intent = Intent(context, EngineService::class.java)
            if (wanted || runs.get() > 0) {
                try {
                    ContextCompat.startForegroundService(context, intent)
                } catch (e: Exception) {
                    // Android refuses a start from the background on some
                    // paths; the download goes on while the app is open.
                    Log.w(TAG, "could not start: $e")
                }
            } else {
                context.stopService(intent)
            }
        }
    }

    private var wakeLock: PowerManager.WakeLock? = null
    private var wifiLock: WifiManager.WifiLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notice = notice()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTICE_ID, notice, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            startForeground(NOTICE_ID, notice)
        }
        holdLocks()
        // Not restarted by itself: with the process gone there is nothing to
        // keep alive, and the app goes on with the unfinished downloads at
        // its next launch.
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        wakeLock?.takeIf { it.isHeld }?.release()
        wifiLock?.takeIf { it.isHeld }?.release()
        super.onDestroy()
    }

    /** The CPU awake and Wi-Fi at full speed while the screen is off. */
    private fun holdLocks() {
        if (wakeLock == null) {
            wakeLock = (getSystemService(Context.POWER_SERVICE) as PowerManager)
                .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "vidhoist:engine")
                .apply { setReferenceCounted(false); acquire() }
        }
        if (wifiLock == null) {
            @Suppress("DEPRECATION")
            wifiLock = (applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager)
                .createWifiLock(WifiManager.WIFI_MODE_FULL_HIGH_PERF, "vidhoist:engine")
                .apply { setReferenceCounted(false); acquire() }
        }
    }

    private fun notice(): Notification {
        val manager = getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL,
                    getString(R.string.engine_channel),
                    NotificationManager.IMPORTANCE_LOW,
                ),
            )
        }
        val open = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE,
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            Notification.Builder(this, CHANNEL)
        else
            @Suppress("DEPRECATION") Notification.Builder(this)
        return builder
            .setSmallIcon(R.drawable.ic_stat_vidhoist)
            .setContentTitle(title)
            .setContentText(text)
            .setContentIntent(open)
            .setOngoing(true)
            .build()
    }
}
