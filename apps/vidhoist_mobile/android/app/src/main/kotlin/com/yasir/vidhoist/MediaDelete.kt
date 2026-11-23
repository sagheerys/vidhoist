package com.yasir.vidhoist

import android.app.Activity
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.MediaStore.Files.FileColumns
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/**
 * Deleting downloads this app **no longer owns**, with the user's consent.
 *
 * Since Android 11 an app deletes by path only the shared files MediaStore
 * records as its own. That record is erased when the app's data is cleared
 * or the app is uninstalled, and a file brought back by a phone transfer
 * never had it; from then on `unlink` answers `ENOENT` for a file that is
 * plainly there, and the gallery deletes it while the app that downloaded
 * it cannot. The system's own answer is a delete request: one dialog for
 * the whole batch, after which the system deletes the files itself.
 */
object MediaDelete {
    private const val REQUEST = 0x4D44

    /** The Dart call waiting for the dialog; one at a time. */
    private var pending: MethodChannel.Result? = null

    fun start(activity: Activity, paths: List<String>, result: MethodChannel.Result) {
        // Android 10 has no batch request, and below it paths simply work.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            result.success(false)
            return
        }
        // A dialog whose answer never came (the activity was recreated
        // under it) must not block every later delete.
        pending?.success(false)
        pending = result
        Thread {
            val found = paths.mapNotNull { entryOf(activity.applicationContext, it) }
            activity.runOnUiThread { ask(activity, found) }
        }.start()
    }

    /** True when the result was the delete dialog's. */
    fun onResult(requestCode: Int, resultCode: Int): Boolean {
        if (requestCode != REQUEST) return false
        answer(resultCode == Activity.RESULT_OK)
        return true
    }

    private fun answer(deleted: Boolean) {
        pending?.success(deleted)
        pending = null
    }

    private class Entry(val uri: Uri, val media: Boolean)

    private fun ask(activity: Activity, found: List<Entry>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return answer(false)
        // Subtitles are accepted beside their clips from Android 12; where
        // they are refused, the clips are still worth deleting without them.
        val attempts = listOf(found, found.filter { it.media }).distinct()
        for (attempt in attempts) {
            if (attempt.isEmpty()) continue
            try {
                val request = MediaStore.createDeleteRequest(
                    activity.contentResolver,
                    attempt.map { it.uri },
                )
                activity.startIntentSenderForResult(
                    request.intentSender, REQUEST, null, 0, 0, 0,
                )
                return
            } catch (_: IllegalArgumentException) {
                // This Android takes media only: try again without the rest.
            } catch (_: Throwable) {
                break
            }
        }
        answer(false)
    }

    /**
     * The file's MediaStore address. A file the gallery has not indexed yet
     * is indexed first, since a delete request names rows, not paths.
     */
    private fun entryOf(context: Context, path: String): Entry? =
        query(context, path) ?: run {
            val indexed = CountDownLatch(1)
            MediaScannerConnection.scanFile(context, arrayOf(path), null) { _, _ ->
                indexed.countDown()
            }
            indexed.await(5, TimeUnit.SECONDS)
            query(context, path)
        }

    private fun query(context: Context, path: String): Entry? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return null
        val files = MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
        val columns = arrayOf(
            FileColumns._ID,
            FileColumns.MEDIA_TYPE,
            FileColumns.VOLUME_NAME,
        )
        return try {
            context.contentResolver.query(
                files, columns, "${FileColumns.DATA} = ?", arrayOf(path), null,
            )?.use { rows ->
                if (!rows.moveToFirst()) return null
                val id = rows.getLong(0)
                val volume = rows.getString(2) ?: MediaStore.VOLUME_EXTERNAL_PRIMARY
                // A request takes each item at its own collection's address.
                when (rows.getInt(1)) {
                    FileColumns.MEDIA_TYPE_VIDEO -> Entry(
                        MediaStore.Video.Media.getContentUri(volume, id), true,
                    )
                    FileColumns.MEDIA_TYPE_AUDIO -> Entry(
                        MediaStore.Audio.Media.getContentUri(volume, id), true,
                    )
                    FileColumns.MEDIA_TYPE_IMAGE -> Entry(
                        MediaStore.Images.Media.getContentUri(volume, id), true,
                    )
                    FileColumns.MEDIA_TYPE_SUBTITLE -> Entry(
                        MediaStore.Files.getContentUri(volume, id), false,
                    )
                    else -> null
                }
            }
        } catch (_: Throwable) {
            null
        }
    }
}
