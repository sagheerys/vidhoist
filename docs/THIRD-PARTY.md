# Third-party software in VidHoist

VidHoist is free software under the [GNU GPL version 3](../LICENSE). Each app
also carries programs written by others. This page lists them, their
licences, and where their source is. The same notices are inside each app
under Settings › About › Open-source licenses.

## Where the source is

The source of every GPL and LGPL program below, at the version shipped, is
on this repository's [releases page](https://github.com/sagheerys/vidhoist/releases),
in a release of its own beside each app release: "Third-party sources for
VidHoist 1.1.0" for 1.1.0, linked from that release's notes. Keeping them
apart leaves the app release with only what installs. Maintainers fetch
those files with `tool/fetch-third-party-sources.ps1` before publishing.

The libraries inside the Android engine's FFmpeg and Python are built by the
[Termux](https://github.com/termux/termux-packages) project's recipes, and
their upstream sources are linked from those recipes. If a source you need
is missing from a release, open an
[issue](https://github.com/sagheerys/vidhoist/issues): for three years after
the last release that contained it, it will be provided at no charge beyond
the cost of sending it.

## The Android app

| Component | Version | Licence | Source |
|---|---|---|---|
| youtubedl-android (runs yt-dlp, Python and FFmpeg inside the app) | 0.18.1 | GPL-3.0 | [yausername/youtubedl-android](https://github.com/yausername/youtubedl-android/tree/0.18.1) |
| yt-dlp | updated by the app | Unlicense | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp) |
| FFmpeg, built with `--enable-gpl --enable-version3` | 7.1.1 | GPL-3.0-or-later | [ffmpeg-7.1.1.tar.xz](https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz) |
| Python with its standard library | 3.12.11 | PSF-2.0 | [Python-3.12.11.tar.xz](https://www.python.org/ftp/python/3.12.11/Python-3.12.11.tar.xz) |
| QuickJS | 2025-04-26 | MIT | [bellard/quickjs](https://github.com/bellard/quickjs) |
| ZXing and ZXing Android Embedded (QR code for pairing) | 4.3.0 | Apache-2.0 | [journeyapps/zxing-android-embedded](https://github.com/journeyapps/zxing-android-embedded) |
| AndroidX, Kotlin | | Apache-2.0 | [developer.android.com](https://developer.android.com/jetpack/androidx) |

Libraries inside FFmpeg: aom, ass, bluray, brotli, bzip2, dav1d, fftw,
fontconfig, freetype, fribidi, GLib, gme, GMP, GnuTLS, graphite2, HarfBuzz,
libiconv, libidn2, Little CMS, LAME, mpg123, Nettle, Ogg, OpenCORE AMR,
libopenmpt, Opus, PCRE2, libpng, rav1e, Rubber Band, libsamplerate,
libsodium, SoX Resampler, SRT, libssh, SVT-AV1, Theora, libudfread,
libunistring, v4l-utils, vid.stab, VMAF, VisualOn AMR-WB, Vorbis, libvpx,
WebP, x264, x265, libxml2, Xvid, xz, zimg, zlib, ZeroMQ.

Libraries inside Python: bzip2, expat, gdbm, libcrypt, libffi, ncurses,
OpenSSL, readline, SQLite, xz, zlib.

## The Windows app

| Component | Version | Licence | Source |
|---|---|---|---|
| yt-dlp, folder build (installed with the app; its own libraries are listed in `tools\yt-dlp\_internal\THIRD_PARTY_LICENSES.txt`) | 2026.10.26 | Unlicense; the bundle as a whole GPL-3.0-or-later | [yt-dlp 2026.10.26](https://github.com/yt-dlp/yt-dlp/tree/2026.10.26) |
| libmpv (the video player), built without GPL parts (`-Dgpl=false`) | mpv v0.36.0-403-g652a1dd907 | LGPL-3.0-or-later | [mpv 652a1dd907](https://github.com/mpv-player/mpv/tree/652a1dd907), [build recipe of release 2023-09-24](https://github.com/media-kit/libmpv-win32-video-build/tree/f5a6f879c9b8bef6a73e52c8c0f35e51636c96e5) |
| FFmpeg inside libmpv (`--disable-gpl --enable-version3`) | 6.0 | LGPL-3.0-or-later | [ffmpeg-6.0.tar.xz](https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz) |
| FFmpeg essentials build, fetched by the app from its publisher on first need | 9.0.2 | GPL-3.0-or-later | [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) |
| Deno, fetched by the app from its publisher on first need | 2.9.8 | MIT | [denoland/deno](https://github.com/denoland/deno) |

`libmpv-2.dll` is a separate file in the app's folder and may be replaced by
another build of libmpv.

## Both apps

| Component | Licence | Source |
|---|---|---|
| Tajawal font, (c) 2017 by Boutros International | OFL-1.1 | [packages/vh_ui/assets/fonts/OFL.txt](../packages/vh_ui/assets/fonts/OFL.txt) |
| Noto Kufi Arabic font, Copyright 2019-2022 Google LLC | OFL-1.1 | as above |
| Noto Sans, Noto Naskh Arabic and Noto Sans Devanagari fonts (Turkish and Russian, Persian and Urdu, Hindi), Copyright 2022 The Noto Project Authors | OFL-1.1 | as above |
| Material Symbols (the pause and download icon shapes) | Apache-2.0 | [google/material-design-icons](https://github.com/google/material-design-icons) |
| Tabler Icons (the queue icon shape) | MIT | [tabler/tabler-icons](https://github.com/tabler/tabler-icons) |
| Dart and Flutter packages | BSD, MIT, Apache-2.0, Zlib, MPL-2.0 | listed with their licences inside each app |

Plugins kept in [`third_party/`](../third_party) carry their own licences and
a `PATCHES.md` describing what was changed.
