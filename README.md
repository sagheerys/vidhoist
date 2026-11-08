# Vidhoist

**Download video and audio from the web, straight to your device, with yt-dlp
inside the app.** No server to run, no account, no ads. Android and Windows,
Arabic and English, day and night.

> **Status: 1.0.0, a beta.** Vidhoist is a fork of
> [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) by the same
> author. The interface, the local library, the players, transcripts, backups
> and self-update come from there; the downloads now run on the device with
> yt-dlp, and nothing needs a server. How the engine runs on each platform is
> in [docs/ENGINE.md](docs/ENGINE.md); why and how the server went, in
> [docs/blueprint/REPORT.md](docs/blueprint/REPORT.md) (Arabic).

| | Vidhoist for Android | Vidhoist for Windows |
|---|---|---|
| Folder | `apps/vidhoist_mobile` | `apps/vidhoist_desktop` |
| Engine | yt-dlp and ffmpeg inside the app (`youtubedl-android`) | `yt-dlp.exe` beside the app; ffmpeg fetched on first need |
| Library | the download folder, scanned locally | a local library with tags, lists and transcripts |
| Install | APK from Releases, self-updating | Inno Setup installer, self-updating |

<p>
  <img src="docs/screenshots/android-add.png" width="200" alt="Adding a link: pick a quality and start">
  <img src="docs/screenshots/android-transcript.png" width="200" alt="The transcript under the player, the line being said lit">
  <img src="docs/screenshots/android-subtitles-ar.png" width="200" alt="Subtitle size and background, in Arabic">
  <img src="docs/screenshots/android-transcript-ar-dark.png" width="200" alt="The transcript at night, in Arabic">
</p>

## Why a fork

Vidhoist Lite and Super are clients for a self-hosted server. Many people want
the same app without running anything: paste a link, pick a quality, keep the
file. Vidhoist is that app. It keeps the "Wahaj" design system and the code
that has nothing to do with the server, and replaces only the engine.

## Building

Flutter 3.47 or later (Dart ^3.13). From the repository root:

```bash
flutter pub get
cd packages/vh_ui && flutter gen-l10n && cd ../..
flutter analyze --no-pub
cd apps/vidhoist_mobile  && flutter build apk --debug
cd apps/vidhoist_desktop && flutter build windows --debug
```

Tests: `dart test` in `packages/vh_core` and `packages/vh_transcripts`;
`flutter test --no-pub` in `packages/vh_media`, `packages/vh_ui`,
`apps/vidhoist_mobile` and `apps/vidhoist_desktop`.

Icons and brand files are generated, not drawn by hand:
`python tool/icons/vidhoist_kit.py`, then `dart run flutter_launcher_icons`
in the Android app.

## Repository map

```
apps/vidhoist_mobile     Android app
apps/vidhoist_desktop    Windows app
packages/vh_core         pure Dart: models, storage, download engine, backup, update
packages/vh_media        players, mini player, media session
packages/vh_ui           the Wahaj design system, tokens, icons, EN/AR strings
packages/vh_transcripts  subtitles and transcript search
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
[vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) للمؤلّف نفسه، وهذا
إصداره الأول 1.0.0 (تجريبي): الواجهة والمكتبة والمشغّلات تعمل، والتنزيل يجري
على الجهاز بـyt-dlp بلا سيرفر. التفاصيل في [README.ar.md](README.ar.md).

</div>
