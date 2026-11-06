# Vidhoist

**Download video and audio from the web, straight to your device, with yt-dlp
inside the app.** No server to run, no account, no ads. Android and Windows,
Arabic and English, day and night.

> **Status: before its first release.** Vidhoist is a fork of
> [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) by the same
> author. The interface, the local library, the players, transcripts, backups
> and self-update come from there; the downloads now run on the device with
> yt-dlp, and nothing needs a server. How the engine runs on each platform is
> in [docs/ENGINE.md](docs/ENGINE.md); why and how the server went, in
> [docs/blueprint/REPORT.md](docs/blueprint/REPORT.md) (Arabic).

| | Vidhoist for Android | Vidhoist for Windows |
|---|---|---|
| Folder | `apps/vidhoist_mobile` | `apps/vidhoist_desktop` |
| Engine | yt-dlp on the device (planned: `youtubedl-android`) | `yt-dlp.exe` + ffmpeg beside the app |
| Library | the download folder, scanned locally | a local library with tags, lists and transcripts |
| Install | APK from Releases, self-updating | Inno Setup installer, self-updating |

## Why a fork

Vidhoist Lite and Super are clients for a self-hosted server. Many people want
the same app without running anything: paste a link, pick a quality, keep the
file. Vidhoist is that app. It keeps the "Wahaj" design system and the code
that has nothing to do with the server, and replaces only the engine.

## Building

Flutter 3.47 or later (Dart ^3.13). From the repository root:

```bash
flutter pub get
cd packages/mt_ui && flutter gen-l10n && cd ../..
flutter analyze --no-pub
cd apps/vidhoist_mobile  && flutter build apk --debug
cd apps/vidhoist_desktop && flutter build windows --debug
```

Tests: `dart test` in `packages/mt_core` and `packages/mt_transcripts`;
`flutter test --no-pub` in `packages/mt_media`, `packages/mt_ui`,
`apps/vidhoist_mobile` and `apps/vidhoist_desktop`.

Icons and brand files are generated, not drawn by hand:
`python tool/icons/vidhoist_kit.py`, then `dart run flutter_launcher_icons`
in the Android app.

## Repository map

```
apps/vidhoist_mobile     Android app
apps/vidhoist_desktop    Windows app
packages/mt_core         pure Dart: models, storage, download engine, backup, update
packages/mt_media        players, mini player, media session
packages/mt_ui           the Wahaj design system, tokens, icons, EN/AR strings
packages/mt_transcripts  subtitles and transcript search
third_party/             two patched plugins, see PATCHES.md in each
docs/                    architecture, blueprint, decisions (docs/adr)
```

The package prefix `mt_` is kept from the parent project so fixes can still be
carried across; the apps and everything a user sees say Vidhoist.

## Licence

GPL-3.0, like the project it comes from. Copyright © 2025–2026 Yasir Sagheer.
Vidhoist is not affiliated with yt-dlp or with any content platform. Respect
copyright and the terms of the sites you download from.

---

<div dir="rtl">

## بالعربية

**Vidhoist** يحمّل الفيديو والصوت من الإنترنت إلى جهازك مباشرة بمحرّك yt-dlp
داخل التطبيق: بلا سيرفر، بلا حساب، بلا إعلانات. لأندرويد وويندوز، بالعربية
والإنجليزية. المشروع نسخة مشتقّة من
[vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) للمؤلّف نفسه، ما زال
قبل إصداره الأول: الواجهة والمكتبة والمشغّلات تعمل، والتنزيل يجري على الجهاز
بـyt-dlp بلا سيرفر. التفاصيل في [README.ar.md](README.ar.md).

</div>
