# VidHoist

**Download video and audio from the web, straight to your device, with yt-dlp
inside the app.** No sign-up, no ads, no tracking: what you download stays
between you and the site. Android and Windows, Arabic and English, day and
night.

> **Status: 1.0.0, a beta.** VidHoist is a fork of
> [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) by the same
> author, and has gone its own way since. How the engine runs on each
> platform is in [docs/ENGINE.md](docs/ENGINE.md).

| | VidHoist for Android | VidHoist for Windows |
|---|---|---|
| Folder | `apps/vidhoist_mobile` | `apps/vidhoist_desktop` |
| Engine | yt-dlp and ffmpeg inside the app (`youtubedl-android`) | `yt-dlp.exe` beside the app; ffmpeg fetched on first need |
| Library | the download folder, with playlists, tags and transcripts | a local library with tags, lists and transcripts |
| Install | APK from Releases, self-updating | Inno Setup installer, self-updating |

<p>
  <img src="docs/screenshots/android-add.png" width="200" alt="Adding a link: pick a quality and start">
  <img src="docs/screenshots/android-transcript.png" width="200" alt="The transcript under the player, the line being said lit">
  <img src="docs/screenshots/android-subtitles-ar.png" width="200" alt="Subtitle size and background, in Arabic">
  <img src="docs/screenshots/android-transcript-ar-dark.png" width="200" alt="The transcript at night, in Arabic">
</p>

## Building

Flutter 3.47 or later (Dart ^3.13). From the repository root:

```bash
flutter pub get
cd packages/vh_ui && flutter gen-l10n && cd ../..
flutter analyze --no-pub
cd apps/vidhoist_mobile  && flutter build apk --debug
cd apps/vidhoist_desktop && flutter build windows --debug
```

Tests: `dart test` in `packages/vh_core`, `packages/vh_transcripts` and
`packages/vh_ytdlp`;
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
packages/vh_ui           the design system, tokens, icons, EN/AR strings
packages/vh_transcripts  subtitles and transcript search
packages/vh_ytdlp        pure Dart: yt-dlp commands and reading its output
third_party/             three patched plugins, see PATCHES.md in each
docs/                    architecture, blueprint, decisions (docs/adr)
```

## Licence

GPL-3.0, like the project it comes from. Copyright © 2026 Yasir Sagheer.
VidHoist is not affiliated with yt-dlp or with any site. Respect
copyright and the terms of the sites you download from.

---

<div dir="rtl">

## بالعربية

**VidHoist** ينزّل الفيديو والصوت من الإنترنت إلى جهازك مباشرة بمحرّك yt-dlp
داخل التطبيق: بلا تسجيل، بلا إعلانات، بلا تتبّع. لأندرويد وويندوز، بالعربية
والإنجليزية. المشروع نسخة مشتقّة من
[vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) للمؤلّف نفسه، وهذا
إصداره الأول 1.0.0 (تجريبي). التفاصيل في [README.ar.md](README.ar.md).

</div>
