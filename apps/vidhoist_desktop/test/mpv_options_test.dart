import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/mpv_options.dart';

void main() {
  test("**the guard**: mpv never draws a subtitle file of its own", () {
    // The fault: the app's Arabic captions and, under them over the seek
    // bar, English ones mpv had loaded by itself from the `.en.vtt`
    // yt-dlp writes beside every video. The app draws the subtitles.
    expect(mpvEngineOptions['sub-auto'], 'no');
  });

  test('a dropped stream is reconnected', () {
    expect(mpvEngineOptions['stream-lavf-o'], contains('reconnect=1'));
  });
}
