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
  for tests. Not used by the apps yet.

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

### Fixed
- Self-update would never have offered a Vidhoist release: the phone looked
  for files named "lite" and Windows for "ember", and Windows saved the
  installer as `Vidhoist-Ember-…`. Both now look for `Vidhoist` and tell the
  APK from the installer by the extension.

### Known, deliberately
- The download layer still speaks to a Vidhoist server. Replacing it is the
  next phase; see the blueprint.
