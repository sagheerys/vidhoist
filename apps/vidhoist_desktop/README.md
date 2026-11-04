# Vidhoist for Windows

The desktop app: a three-column shell (navigation, library, downloads) with a
local library of tags, lists, transcripts and covers, a tray icon and a
`vidhoist://add?url=` link handler for the browser button.

- Identity: `lib/identity.dart` (`Vidhoist`, which also names
  `%APPDATA%\Vidhoist`), `windows/runner/Runner.rc`, and the installer
  `windows/installer/vidhoist.iss` with its own AppId. None of these change
  after the first release.
- Brand files in `brand/`, the Windows icon, the tray icons and the installer
  images all come from `tool/icons/vidhoist_kit.py`.
- Build: `flutter build windows --release --no-pub` here, then Inno Setup 6 on
  `windows/installer/vidhoist.iss` (the CI job shows the exact call).
- Tests: `flutter test --no-pub`; window sizes and font scales are covered by
  `test/desktop_matrix.dart`.

The download engine is being moved from a Vidhoist server to `yt-dlp.exe`
beside the app; see `docs/blueprint/REPORT.md` at the repository root.
