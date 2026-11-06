# Changelog

All notable changes to Vidhoist. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- The project. Vidhoist starts from
  [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) v2.7.0
  (2026-11-03) by the same author, with two of its three apps: the Android
  app (from Vidhoist Lite) and the Windows app (from Vidhoist Ember). Vidhoist Super
  is not carried over.
- A new identity: the name, a blue accent (`#2457D6` by day, `#7FA3FF` by
  night), a white ground by day and a black one by night, and a mark whose
  window carries a download arrow landing in a tray. Everything is generated
  by `tool/icons/vidhoist_kit.py`.
- `docs/blueprint/REPORT.md`: the plan for replacing the Vidhoist server with
  yt-dlp running on the device, and `docs/adr/` for the decisions taken.
- `docs/ENGINE.md`: yt-dlp measured on Windows, on the Android emulator and on
  a phone before any engine code, with the real output kept as test fixtures.
- `packages/mt_ytdlp`: the yt-dlp command lines (format selectors, IPv4 by
  default, downloading from a probe's info JSON), and reading what yt-dlp
  prints back: progress, the parts of a merged download, the finished file,
  the info JSON, classified errors and the engine's version. Pure Dart, not
  yet used by the apps.
- In `mt_core`, beside the server engine: `DownloadBackend` (yt-dlp on the
  device, one implementation per app), `LocalDownloadEngine` (probe once and
  download from the probe, pause and resume, a Wi-Fi gate before starting,
  one retry at best when a height cannot be met, unfinished downloads queued
  again at the next launch), `LocalHistoryStore` (the library's records kept
  on the device, in the fields the server's history had) and `FakeBackend`
  for tests.
- Both apps download with yt-dlp on the device; no Vidhoist server is needed.
  - Android: yt-dlp through youtubedl-android, unpacked and updated on first
    run from a welcome screen. Downloads go on with the app swiped away,
    pause and resume from the card or the notification, Wi-Fi only pauses
    and resumes with the connection, and subtitles are saved beside the clip
    and shown by the player. An "Engine" section in Settings shows the
    version, updates yt-dlp and turns IPv4 on or off. APKs are built per ABI
    and self-update picks the one for the device.
  - Windows: yt-dlp as a process with no console window; cancelling stops
    yt-dlp, Deno and ffmpeg together. ffmpeg and Deno are fetched on first
    need, each checked against a pinned SHA-256. A welcome dialog, an engine
    line in the sidebar and a Settings › Engine pane replace the server
    setup. Cookies come from local files or from a browser. The installer
    ships yt-dlp (`tool/fetch-engine.ps1`).

### Changed
- Package and application identifiers: `apps/vidhoist_mobile`
  (`com.yasir.vidhoist`), `apps/vidhoist_desktop` (`Vidhoist`,
  `%APPDATA%\Vidhoist`, link scheme `vidhoist://`, a new installer AppId).
  The download folder is `Download/Vidhoist`. Self-update reads
  `sagheerys/vidhoist` releases.
- User-facing strings that named Vidhoist, Lite, Super or Ember now say
  Vidhoist, in English and Arabic alike. Strings about the server are kept
  until the engine is replaced.

- **Brought level with vidhoist-mobile v2.7.0 as released** (tag `v2.7.0`,
  `32e12c5d`, 2026-11-05). The copy of 2026-11-03 was two days of work short
  of the release: copying a clip's file with Ctrl+C on Windows, quiet rows for
  the smart playlists on the phone, a 360p choice, video lists without the
  shorts, Windows folders named after the app (`Downloads\Vidhoist`,
  `Videos\Vidhoist\Offline`), a note when a synced device goes quiet, and
  the parent's security hardening (links open only as web pages, folders stay
  inside their own, updates only from GitHub over https). A patched
  `media_kit_video` in `third_party/` stops Windows closing when a clip of
  another size starts. Brought in with `tool/port_from_vidhoist.py`.
- The sync subfolder is `Vidhoist Sync`, so Vidhoist and Vidhoist never share
  one library when pointed at the same synced folder.
- By day, white cards stand on a soft stone ground (`#F2F1EE`) instead of a
  white one, which glared and left the cards only a hairline to stand on.
- Windows hides Channels and Sync unless they are switched on in
  Settings › Engine; they still need a server. The taskbar badge is blue.

### Fixed
- Self-update would never have offered a Vidhoist release: the phone looked
  for files named "lite" and Windows for "ember", and Windows saved the
  installer as `Vidhoist-Ember-…`. Both now look for `Vidhoist` and tell the
  APK from the installer by the extension.
- The phone still saved into `Download/Vidhoist_Lite`; it now uses
  `Download/Vidhoist`, as the identity said.

### Known, deliberately
- The server code is still in the tree, unused by the downloads; batch 6
  removes it.
