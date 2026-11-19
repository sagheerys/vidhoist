import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **The licence page** names what each app carries beyond its Dart
/// packages: the installer's licence page promises it, and the GPL and
/// LGPL programs inside the apps require their notices to travel with them.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Set<String> names(VhNoticeSet set) => {
    for (final notice in vhNoticesFor(set)) ...notice.packages,
  };

  test('**the guard**: the phone lists the engine it carries, and the '
      'fonts and icons both apps use', () {
    expect(
      names(VhNoticeSet.android),
      containsAll([
        'youtubedl-android',
        'yt-dlp',
        'FFmpeg',
        'Python',
        'QuickJS',
        'ZXing',
        'Tajawal',
        'Noto Kufi Arabic',
        'Material Symbols',
        'Tabler Icons',
      ]),
    );
  });

  test('**the guard**: Windows lists its player library and what it '
      'fetches, and the fonts and icons', () {
    expect(
      names(VhNoticeSet.windows),
      containsAll([
        'yt-dlp',
        'mpv',
        'FFmpeg',
        'Deno',
        'Tajawal',
        'Noto Kufi Arabic',
        'Material Symbols',
        'Tabler Icons',
      ]),
    );
  });

  test('every notice names a licence text that is there, and says what it '
      'covers', () {
    for (final set in VhNoticeSet.values) {
      for (final notice in vhNoticesFor(set)) {
        final file = File('assets/licenses/${notice.license}.txt');
        expect(file.existsSync(), isTrue, reason: file.path);
        expect(file.readAsStringSync().trim(), isNotEmpty);
        expect(notice.header.trim(), isNotEmpty, reason: '${notice.packages}');
      }
    }
  });

  test('the page reads each text in full', () async {
    registerVhLicenses(VhNoticeSet.android);
    final entries = await LicenseRegistry.licenses.toList();
    final ffmpeg = entries.firstWhere((e) => e.packages.contains('FFmpeg'));
    final text = ffmpeg.paragraphs.map((p) => p.text).join('\n');
    expect(text, contains('FFmpeg 7.1.1'));
    expect(text, contains('GNU GENERAL PUBLIC LICENSE'));
  });
}
