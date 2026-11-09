package com.yasir.vidhoist

import android.content.Context
import android.os.Build
import android.os.Environment
import android.os.storage.StorageManager

/**
 * The memory cards and drives mounted beside the phone's own storage, for
 * the "where downloads go" setting (`phone_volumes.dart`).
 *
 * **Android 11 and later only.** From 11 an app may write its own files in
 * a card's `Download` folder by path, which is how yt-dlp writes; before
 * it, a card took the file picker's `content://` grants, and a path-only
 * app cannot use those. An older phone simply lists no card. The phone's
 * own storage is left out: the Dart side always has it.
 */
object StorageVolumes {
    fun list(context: Context): List<Map<String, String>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return emptyList()
        val manager = context.getSystemService(StorageManager::class.java)
            ?: return emptyList()
        return manager.storageVolumes.mapNotNull { volume ->
            if (volume.isPrimary) return@mapNotNull null
            if (volume.state != Environment.MEDIA_MOUNTED) return@mapNotNull null
            val id = volume.uuid ?: return@mapNotNull null
            val dir = volume.directory ?: return@mapNotNull null
            mapOf(
                "id" to id,
                "path" to dir.absolutePath,
                "label" to volume.getDescription(context),
            )
        }
    }
}
