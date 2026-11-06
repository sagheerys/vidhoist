package com.yasir.vidhoist

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.yausername.ffmpeg.FFmpeg
import com.yausername.youtubedl_android.YoutubeDL
import com.yausername.youtubedl_android.YoutubeDLException
import com.yausername.youtubedl_android.YoutubeDLRequest
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * yt-dlp on the phone through youtubedl-android, for Dart's
 * `MethodChannelYtDlpBridge`.
 *
 * Every call that touches the library runs on a worker thread: unpacking
 * Python takes seconds the first time, a YouTube probe nearly a minute, and
 * the UI thread must never wait on either. Answers and lines go back on the
 * main thread, in the order they happened.
 *
 * The argument list arrives whole and goes in with `addCommands`: the
 * library's `addOption` groups options by name and reorders them, so a
 * second `-f` or `--print` lands in the wrong place (docs/ENGINE.md,
 * finding 21).
 *
 * An object rather than a class: audio_service keeps one Flutter engine for
 * the life of the process, so a new activity (the app reopened after being
 * swiped away while a download runs) gets the same messenger. Registering
 * again would drop the sink Dart already listens on, and the running
 * download's lines with it.
 */
object YtDlpBridge {
    private const val METHODS = "vidhoist/ytdlp"
    private const val LINES = "vidhoist/ytdlp/lines"

    private val main = Handler(Looper.getMainLooper())
    private val workers = Executors.newCachedThreadPool()
    private var messenger: BinaryMessenger? = null
    private var sink: EventChannel.EventSink? = null
    private lateinit var context: Context

    @Volatile
    private var initialised = false
    private val initLock = Any()

    fun register(context: Context, messenger: BinaryMessenger) {
        this.context = context.applicationContext
        if (this.messenger === messenger) return
        this.messenger = messenger
        MethodChannel(messenger, METHODS).setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> work(result, "init_failed") {
                    val started = System.currentTimeMillis()
                    ensureInit()
                    mapOf("ms" to System.currentTimeMillis() - started)
                }
                "version" -> work(result, "version_failed") {
                    YoutubeDL.getInstance().version(this.context)
                }
                "update" -> work(result, "update_failed") {
                    ensureInit()
                    val channel = if (call.argument<String>("channel") == "nightly")
                        YoutubeDL.UpdateChannel.NIGHTLY
                    else
                        YoutubeDL.UpdateChannel.STABLE
                    val status = YoutubeDL.getInstance().updateYoutubeDL(this.context, channel)
                    mapOf(
                        "status" to status?.name,
                        "version" to YoutubeDL.getInstance().version(this.context),
                    )
                }
                "execute" -> {
                    val id = call.argument<String>("id")
                    val args = call.argument<List<String>>("args")
                    if (id == null || args == null) {
                        result.error("bad_args", "id and args are required", null)
                    } else {
                        workers.execute {
                            execute(id, args, call.argument<String>("stdoutFile"), result)
                        }
                    }
                }
                "cancel" -> {
                    val id = call.argument<String>("id")
                    result.success(id != null && YoutubeDL.getInstance().destroyProcessById(id))
                }
                else -> result.notImplemented()
            }
        }
        EventChannel(messenger, LINES).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                sink = events
            }

            override fun onCancel(arguments: Any?) {
                sink = null
            }
        })
    }

    /** Python and ffmpeg unpacked once per process, whoever asks first. */
    private fun ensureInit() {
        if (initialised) return
        synchronized(initLock) {
            if (initialised) return
            YoutubeDL.getInstance().init(context)
            FFmpeg.getInstance().init(context)
            initialised = true
        }
    }

    private fun work(result: MethodChannel.Result, code: String, body: () -> Any?) {
        workers.execute {
            try {
                val value = body()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error(code, e.message ?: e.toString(), null) }
            }
        }
    }

    /**
     * One run. Every line starting with `[` (the ones the app's templates
     * print) goes to Dart as it comes, then the end marker, then the
     * answer. A non-zero exit reaches here as an exception carrying stderr,
     * and a run stopped by [cancel] as the library's CanceledException.
     */
    private fun execute(
        id: String,
        args: List<String>,
        stdoutFile: String?,
        result: MethodChannel.Result,
    ) {
        val end: Map<String, Any?> = try {
            ensureInit()
            val request = YoutubeDLRequest(emptyList<String>()).apply { addCommands(args) }
            val response = YoutubeDL.getInstance().execute(request, id) { _, _, line ->
                main.post { sink?.success(mapOf("id" to id, "line" to line)) }
            }
            stdoutFile?.let { File(it).writeText(response.out) }
            mapOf("exitCode" to response.exitCode, "stderr" to response.err)
        } catch (e: YoutubeDL.CanceledException) {
            mapOf("exitCode" to 1, "stderr" to "", "cancelled" to true)
        } catch (e: YoutubeDLException) {
            mapOf("exitCode" to 1, "stderr" to (e.message ?: ""))
        } catch (e: Exception) {
            mapOf("exitCode" to 1, "stderr" to "ERROR: $e")
        }
        main.post {
            sink?.success(mapOf("id" to id, "done" to true))
            result.success(end)
        }
    }
}
