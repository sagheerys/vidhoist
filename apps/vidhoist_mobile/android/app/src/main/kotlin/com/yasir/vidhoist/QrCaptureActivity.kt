package com.yasir.vidhoist

import android.os.Bundle
import android.util.TypedValue
import android.view.View
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.journeyapps.barcodescanner.CaptureActivity

/**
 * zxing's scanner screen, kept clear of the system's bars. Android 15 and
 * later draw every screen under them, and the library's line along the
 * bottom ("point the camera at the QR code") went under the gesture bar,
 * cut off or gone. The camera still fills the screen; only the line moves
 * up by the bars' height, and in from a cut-out at the side.
 */
class QrCaptureActivity : CaptureActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val line = findViewById<View>(com.google.zxing.client.android.R.id.zxing_status_view)
            ?: return
        val gap = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP, 24f, resources.displayMetrics,
        ).toInt()
        val start = line.paddingStart
        val end = line.paddingEnd
        ViewCompat.setOnApplyWindowInsetsListener(line) { view, insets ->
            val bars = insets.getInsets(
                WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout(),
            )
            view.setPaddingRelative(start + bars.left, view.paddingTop, end + bars.right, bars.bottom + gap)
            insets
        }
        ViewCompat.requestApplyInsets(line)
    }
}
