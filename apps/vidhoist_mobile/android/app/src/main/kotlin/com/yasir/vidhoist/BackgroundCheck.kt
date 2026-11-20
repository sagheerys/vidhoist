package com.yasir.vidhoist

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit
import kotlin.coroutines.resume
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull

/**
 * **The channel check made while the app is closed**, which the user turns
 * on in the channels page. Android's scheduler runs it about every six
 * hours, with a network and a battery that is not low, at a moment of its
 * choosing among other apps' work.
 *
 * It only reads and tells (`background_main.dart`); downloading stays the
 * app's, so nothing here needs a foreground service or outlives the
 * scheduler's few minutes.
 *
 * Three cases, by what is alive when it fires:
 * - the app in sight: nothing, its own check runs;
 * - the app's engine alive out of sight: that engine is asked to check, as
 *   a second engine would take over [YtDlpBridge]'s lines from it;
 * - no engine: one is started without a window and let go once it is done.
 */
object BackgroundCheck {
    private const val TAG = "BackgroundCheck"
    private const val CHANNEL = "vidhoist/background"
    private const val PERIODIC = "vidhoist.channels.periodic"
    private const val SOON = "vidhoist.channels.soon"

    /** The Dart function the engine of its own runs (`main.dart`). */
    private const val ENTRYPOINT = "backgroundCheck"

    /** Ends a check that never says it is done, well before Android does. */
    private val LIMIT = TimeUnit.MINUTES.toMillis(8)

    private val main = Handler(Looper.getMainLooper())

    /** Set by [MainActivity] between its start and stop. */
    @Volatile
    var inSight = false

    /** The app's own engine, while it lives. */
    @Volatile
    var appMessenger: BinaryMessenger? = null

    /**
     * The app's engine: the schedule switch, and the scheduler's runs. It is
     * forgotten when the engine ends, not when the window does: the audio
     * player keeps the engine past its window, and a second engine beside
     * a live one would take over [YtDlpBridge] from it.
     */
    fun registerApp(context: Context, engine: FlutterEngine) {
        val messenger = engine.dartExecutor.binaryMessenger
        appMessenger = messenger
        engine.addEngineLifecycleListener(object : FlutterEngine.EngineLifecycleListener {
            override fun onPreEngineRestart() {}

            override fun onEngineWillDestroy() {
                if (appMessenger === messenger) appMessenger = null
            }
        })
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "schedule" -> {
                    schedule(
                        context.applicationContext,
                        call.argument<Boolean>("on") == true,
                        call.argument<Boolean>("soon") == true,
                    )
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun schedule(context: Context, on: Boolean, soon: Boolean) {
        val work = WorkManager.getInstance(context)
        if (!on) {
            work.cancelUniqueWork(PERIODIC)
            work.cancelUniqueWork(SOON)
            return
        }
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .setRequiresBatteryNotLow(true)
            .build()
        // Kept as it is when already there: making it again at every start
        // would push the next check six hours on each time. No delay of its
        // own: Android already holds each run to the last hour of its six,
        // and a delay on top put the first one eleven hours on.
        work.enqueueUniquePeriodicWork(
            PERIODIC,
            ExistingPeriodicWorkPolicy.KEEP,
            PeriodicWorkRequestBuilder<ChannelCheckWorker>(6, TimeUnit.HOURS, 1, TimeUnit.HOURS)
                .setConstraints(constraints)
                .build(),
        )
        if (soon) {
            work.enqueueUniqueWork(
                SOON,
                ExistingWorkPolicy.REPLACE,
                OneTimeWorkRequestBuilder<ChannelCheckWorker>()
                    .setConstraints(constraints)
                    .setInitialDelay(15, TimeUnit.MINUTES)
                    .build(),
            )
        }
    }

    /** One check, by whichever of the three cases holds. */
    suspend fun run(context: Context) {
        if (inSight) return
        withTimeoutOrNull(LIMIT) {
            withContext(Dispatchers.Main) {
                val app = appMessenger
                if (app != null) askApp(app) else ownEngine(context)
            }
        } ?: Log.w(TAG, "check did not finish in time")
    }

    private suspend fun askApp(messenger: BinaryMessenger) =
        suspendCancellableCoroutine { done ->
            MethodChannel(messenger, CHANNEL).invokeMethod(
                "run",
                null,
                object : MethodChannel.Result {
                    override fun success(result: Any?) = done.resume(Unit)
                    override fun error(code: String, message: String?, details: Any?) =
                        done.resume(Unit)
                    override fun notImplemented() = done.resume(Unit)
                },
            )
        }

    private suspend fun ownEngine(context: Context) {
        val loader = FlutterInjector.instance().flutterLoader()
        loader.startInitialization(context)
        suspendCancellableCoroutine { ready ->
            loader.ensureInitializationCompleteAsync(context, null, main) { ready.resume(Unit) }
        }
        // Plugins are registered by the engine itself; the yt-dlp bridge is
        // the app's own, and the app's engine takes it back if it opens.
        val engine = FlutterEngine(context)
        try {
            YtDlpBridge.register(context, engine)
            suspendCancellableCoroutine { done ->
                MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                    .setMethodCallHandler { call, result ->
                        result.success(null)
                        if (call.method == "done" && done.isActive) done.resume(Unit)
                    }
                engine.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint(loader.findAppBundlePath(), ENTRYPOINT),
                )
            }
        } finally {
            engine.destroy()
        }
    }
}

/** What the scheduler runs; always a success, so a failed check is not retried at once. */
class ChannelCheckWorker(context: Context, params: WorkerParameters) :
    CoroutineWorker(context, params) {
    override suspend fun doWork(): Result {
        try {
            BackgroundCheck.run(applicationContext)
        } catch (e: Exception) {
            Log.w("BackgroundCheck", "check failed: $e")
        }
        return Result.success()
    }
}
