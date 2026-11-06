import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/media_kit_port.dart';

void main() {
  test("**the guard**: mpv never draws a subtitle file of its own", () {
    // Owner, 2026-11-07: the app's Arabic captions and, under them over the
    // seek bar, English ones mpv had loaded by itself from the `.en.vtt`
    // yt-dlp writes beside every video. The app draws the subtitles.
    expect(MediaKitPort.engineOptions['sub-auto'], 'no');
  });

  test('a dropped stream is reconnected', () {
    expect(
      MediaKitPort.engineOptions['stream-lavf-o'],
      contains('reconnect=1'),
    );
  });
}
