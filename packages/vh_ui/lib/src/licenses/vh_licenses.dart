import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Which app's notices to add: each carries different programs inside it.
enum VhNoticeSet { android, windows }

/// Adds what the app carries beyond its Dart packages to the licence page:
/// the fonts, the three borrowed icon shapes, and the programs each app
/// ships or fetches. Flutter lists the Dart packages by itself; without
/// these, the page omitted FFmpeg, Python and yt-dlp, which the installer's
/// licence page says are listed there.
///
/// Called once at startup by each app. The texts are read from this
/// package's assets only when the page is opened.
void registerVhLicenses(VhNoticeSet set) {
  final notices = vhNoticesFor(set);
  LicenseRegistry.addLicense(() async* {
    for (final notice in notices) {
      final text = await rootBundle.loadString(
        'packages/vh_ui/assets/licenses/${notice.license}.txt',
      );
      yield LicenseEntryWithLineBreaks(
        notice.packages,
        '${notice.header}\n\n$text',
      );
    }
  });
}

/// One entry on the page: who it covers, what it is and where its source
/// is, then the licence text named by [license] (a file in
/// `assets/licenses`).
@visibleForTesting
class VhLicenseNotice {
  const VhLicenseNotice(this.packages, this.license, this.header);

  final List<String> packages;
  final String license;
  final String header;
}

/// Every notice [set] adds, for the tests.
@visibleForTesting
List<VhLicenseNotice> vhNoticesFor(VhNoticeSet set) => [
  ..._shared,
  ...switch (set) {
    VhNoticeSet.android => _android,
    VhNoticeSet.windows => _windows,
  },
];

const _shared = [
  VhLicenseNotice(
    ['Tajawal'],
    'OFL-1.1',
    '(c) 2017 by Boutros International. The text font of both apps.',
  ),
  VhLicenseNotice(
    ['Noto Kufi Arabic'],
    'OFL-1.1',
    'Copyright 2019-2022 Google LLC. The heading font of both apps.',
  ),
  VhLicenseNotice(
    ['Noto Sans', 'Noto Naskh Arabic', 'Noto Sans Devanagari'],
    'OFL-1.1',
    'Copyright 2022 The Noto Project Authors. The fonts of the languages '
        'Tajawal lacks letters of: Turkish and Russian, Persian and Urdu, '
        'and Hindi.',
  ),
  VhLicenseNotice(
    ['Material Symbols'],
    'Apache-2.0',
    'Copyright Google LLC. The pause and download icon shapes.',
  ),
  VhLicenseNotice(
    ['Tabler Icons'],
    'MIT',
    'Copyright (c) 2020-2024 Paweł Kuna. The queue icon shape.',
  ),
];

const _android = [
  VhLicenseNotice(
    ['youtubedl-android'],
    'GPL-3.0',
    'youtubedl-android 0.18.1, which carries yt-dlp, Python, QuickJS and '
        'FFmpeg into the app. Source: '
        'https://github.com/yausername/youtubedl-android/tree/0.18.1',
  ),
  VhLicenseNotice(
    ['yt-dlp'],
    'Unlicense',
    'yt-dlp, released into the public domain. Source: '
        'https://github.com/yt-dlp/yt-dlp',
  ),
  VhLicenseNotice(
    ['FFmpeg'],
    'GPL-3.0',
    'FFmpeg 7.1.1, built with --enable-gpl --enable-version3 together with '
        'x264, x265, Xvid, libvpx, dav1d, rav1e and other libraries, so the '
        'whole is under the GNU GPL version 3 or later. Copyright the FFmpeg '
        'developers and the authors of each library. Source: '
        'https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz; the full list is in '
        'docs/THIRD-PARTY.md of VidHoist\'s repository.',
  ),
  VhLicenseNotice(
    ['Python'],
    'PSF-2.0',
    'Python 3.12.11 with its standard library. Copyright (c) 2001 Python '
        'Software Foundation; All Rights Reserved. Source: '
        'https://www.python.org/ftp/python/3.12.11/',
  ),
  VhLicenseNotice(
    ['QuickJS'],
    'MIT',
    'QuickJS 2025-04-26, used by yt-dlp to read some sites\' players.\n'
        'Copyright (c) 2017-2021 Fabrice Bellard\n'
        'Copyright (c) 2017-2021 Charlie Gordon',
  ),
  VhLicenseNotice(
    ['ZXing', 'ZXing Android Embedded'],
    'Apache-2.0',
    'Copyright the ZXing authors. Reads the QR code that pairs the phone '
        'with a computer.',
  ),
  VhLicenseNotice(
    ['AndroidX', 'Kotlin'],
    'Apache-2.0',
    'Copyright The Android Open Source Project; copyright JetBrains s.r.o. '
        'and Kotlin contributors.',
  ),
];

const _windows = [
  VhLicenseNotice(
    ['yt-dlp'],
    'Unlicense',
    'yt-dlp for Windows, released into the public domain. The libraries '
        'packed inside it are listed with their licences in '
        'tools\\yt-dlp\\_internal\\THIRD_PARTY_LICENSES.txt in the app\'s '
        'folder. Source: https://github.com/yt-dlp/yt-dlp',
  ),
  VhLicenseNotice(
    ['mpv', 'FFmpeg (in libmpv)'],
    'LGPL-3.0',
    'libmpv with FFmpeg, the video player inside the app, built without '
        'their GPL parts (mpv -Dgpl=false, FFmpeg --disable-gpl '
        '--enable-version3), so under the GNU LGPL version 3 or later. It is '
        'the separate file libmpv-2.dll and may be replaced. Source: '
        'https://github.com/media-kit/libmpv-win32-video-build/tree/f5a6f879c9b8',
  ),
  VhLicenseNotice(
    ['FFmpeg'],
    'GPL-3.0',
    'FFmpeg essentials build by Gyan Doshi, fetched from its publisher the '
        'first time it is needed, under the GNU GPL version 3 or later. '
        'Source: https://www.gyan.dev/ffmpeg/builds/',
  ),
  VhLicenseNotice(
    ['Deno'],
    'MIT',
    'Deno, fetched from its publisher the first time it is needed, used by '
        'yt-dlp to read some sites\' players.\n'
        'Copyright 2018-2026 the Deno authors',
  ),
];
