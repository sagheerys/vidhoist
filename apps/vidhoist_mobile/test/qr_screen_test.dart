import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **The guard**: the pairing camera opens the app's own copy of zxing's
/// screen, which keeps its bottom line above the gesture bar. The library's
/// own put "point the camera at the QR code" under it on Android 15 and
/// later, which draw every screen beneath the system's bars.
void main() {
  const kotlin = 'android/app/src/main/kotlin/com/yasir/vidhoist';
  final manifest = File('android/app/src/main/AndroidManifest.xml')
      .readAsStringSync();
  final scanner = File('$kotlin/QrScanner.kt').readAsStringSync();
  final screen = File('$kotlin/QrCaptureActivity.kt').readAsStringSync();

  test('the scanner opens the screen that minds the bars', () {
    expect(
      scanner,
      contains('setCaptureActivity(QrCaptureActivity::class.java)'),
    );
    expect(manifest, contains('android:name=".QrCaptureActivity"'));
    expect(screen, contains('WindowInsetsCompat.Type.systemBars()'));
    expect(screen, contains('zxing_status_view'));
  });
}
