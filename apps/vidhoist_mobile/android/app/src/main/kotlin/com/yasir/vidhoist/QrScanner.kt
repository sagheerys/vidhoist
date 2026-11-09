package com.yasir.vidhoist

import android.app.Activity
import android.content.Intent
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions
import io.flutter.plugin.common.MethodChannel

/**
 * The camera on the computer's pairing QR code (docs/PC-LINK.md), with
 * zxing-android-embedded: open source (Apache 2.0) and without Google Play
 * services, which a GPL app on any phone cannot count on. Its own screen
 * asks for the camera when opened, so the app never holds the permission
 * before the owner presses "Scan".
 */
object QrScanner {
    private const val REQUEST = 0x5143

    /** The Dart call waiting for the scan; one at a time. */
    private var pending: MethodChannel.Result? = null

    fun start(activity: Activity, prompt: String, result: MethodChannel.Result) {
        // A second press while the first is open answers the first empty.
        pending?.success(null)
        pending = result
        val intent = ScanOptions()
            .setDesiredBarcodeFormats(ScanOptions.QR_CODE)
            .setPrompt(prompt)
            .setBeepEnabled(false)
            // Follows the phone, held upright, rather than the library's
            // landscape default (see the activity in the manifest).
            .setOrientationLocked(false)
            .createScanIntent(activity)
        activity.startActivityForResult(intent, REQUEST)
    }

    /** True when the result was the scanner's. */
    fun onResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST) return false
        val contents = ScanIntentResult.parseActivityResult(resultCode, data).contents
        pending?.success(contents)
        pending = null
        return true
    }
}
