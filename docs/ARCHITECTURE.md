# Architecture

A map of the repository for someone who has just cloned it. It answers
three questions: what the pieces are, which rules hold them together, and
where a change belongs.

VidHoist has no server: both apps download on the device itself with
yt-dlp. How yt-dlp runs, what was measured, and the traps are in
[ENGINE.md](ENGINE.md). The optional link that lets the phone send links
to the computer is in [PC-LINK.md](PC-LINK.md).

## 1. Two apps, one repository

| | **Android** (`apps/vidhoist_mobile`) | **Windows** (`apps/vidhoist_desktop`) |
|---|---|---|
| yt-dlp runs through | youtubedl-android (`YtDlpBridge.kt`, `ChannelYtDlpBackend`), kept alive by `EngineService.kt` | `yt-dlp.exe` beside the app or in `tools\` (`ProcessYtDlpBackend`, a Job object per run), with ffmpeg and Deno fetched on first need |
| Library | The download folder, scanned (`Download/VidHoist`, and the same folder on a memory card) | `LocalHistoryStore` and a watch on the download folder |
| At once | One download | One download |
| Only here | Wi-Fi-only downloading, the share sheet, picture in picture, a sign-in page per site (Settings › Accounts) | Tags, lists, reading room, browser button, tray, channels; cookies from a file or the computer's browser (Settings › Cookies) |
| Phone ↔ computer link | The client (Computer tab) | The server (Settings › Phone) |

They are separate apps, not build flavours, with **one palette**
(`VhPalette`, [ADR 0002](adr/0002-identity.md)). They share five packages.
Before changing anything in a shared package, ask: **does this change the
other app?**

## 2. Packages and the dependency rule

```
apps/vidhoist_mobile, apps/vidhoist_desktop
   ├─► vh_media ──────────┬─► vh_core ─► vh_ytdlp
   │      └─► vh_ui       │
   ├─► vh_transcripts ────┘
   ├─► vh_ui
   └─► vh_core
```

Arrows point from a package to what it imports. Nothing imports upwards:
`vh_ytdlp` and `vh_ui` depend on no other package of this repository,
and no package imports an app.

| Package | Contains | Hard rule |
|---|---|---|
| `vh_ytdlp` | yt-dlp's command lines and reading what it prints: format selectors, progress and file lines, the info JSON, errors (`ErrorClassifier`), versions | **Pure Dart, no dependencies, no processes.** Tested on real yt-dlp output (`test/fixtures/`) |
| `vh_core` | `DownloadBackend` (implemented by each app), `LocalDownloadEngine`, `LocalHistoryStore`, `LocalPendingStore`, the models, storage, backup, sync, URL tools, self-update, the link to the computer (`pc_link`: protocol, certificate, server, pinned client) | **Pure Dart. No Flutter import.** Tested with `dart test` |
| `vh_media` | Audio handler, video playback, playback stores, the library model | Plays files on the device |
| `vh_ui` | Design tokens, themes, shared widgets, localisation | Knows no engine and no app |
| `vh_transcripts` | Subtitle parsing, Arabic-aware search, the transcript store, `YtDlpSource` for clips already in the library | **Pure Dart** |
| `apps/*` | Screens, routing, dependency injection, the platform's way of running yt-dlp | May depend on the packages above |

Three consequences worth remembering:

- **One reading of yt-dlp.** A command line is built by `CommandBuilder`,
  and what comes back is parsed by `vh_ytdlp` alone. The apps only start
  the process and hand its lines to `readDownloadRun` (in `vh_core`, which
  uses `vh_ytdlp`'s parsers). A download and the transcript backfill
  classify an error the same way (`ErrorClassifier`).
- **No hard-coded UI strings.** Every user-visible string lives in
  `packages/vh_ui/lib/src/l10n/app_en.arb` and `app_ar.arb`, and both
  files change in the same commit. A parity test enforces it.
- **No hard-coded colours or spacing.** Both come from
  `packages/vh_ui/lib/src/tokens/`. A literal colour works in daylight and
  breaks at night.

## 3. Where a feature lives

An app feature is a folder under `apps/<app>/lib/features/<name>/`. For
example, the Android app's self-update:

```
apps/vidhoist_mobile/lib/features/update/
  update_state.dart      # Riverpod providers + the controller
  update_channel.dart    # platform channel wrapper
  update_section.dart    # widget embedded in another screen
  update_sheet.dart      # bottom sheet
  whats_new_prompt.dart  # a prompt shown after an update
```

A larger feature keeps its bigger widgets in a `widgets/` subfolder
(for example `features/downloads_library/widgets/`).

Rules of thumb:

- Logic that does not need Flutter goes to `vh_core` (or `vh_ytdlp`, when
  it is about yt-dlp's text) and gets a `dart test`.
- A widget used by both apps goes to `vh_ui`. A widget used by one app,
  or one that reads app providers, stays in the app.
- Some files are deliberately duplicated between the two apps
  (`error_text.dart`, `clip_length.dart`, `open_web_link.dart`). When you
  edit one, edit the other or say in the commit why not.
- **Size limits: 400 lines for a screen, 300 for anything else**,
  counting code and excluding comments.

## 4. State and navigation

Riverpod handles dependency injection. `apps/<app>/lib/di.dart` (and the
`data/` folder on Windows) is the wiring: a settings change rebuilds the
engine automatically, with no manual synchronisation.

`apps/<app>/lib/router.dart` holds the whole route table using
`go_router`. There is no direct `Navigator.push` for a screen; sheets and
dialogs are pushed normally.

Storage is `SharedPreferences` behind the `KeyValueStore` interface, so
`vh_core` can be tested with `MemoryKeyValueStore`. **Every
read-modify-write goes through `PrefsMutex`**: without the lock, two
concurrent flows read the same value and the slower one erases the
faster one's write. The keys and the backup format are in
[ENGINE.md › Storage](ENGINE.md#what-carried-over-storage-backups-and-keys).

## 5. Running it

```bash
flutter pub get                      # once, at the repository root
flutter analyze --no-pub             # zero issues is the gate
cd packages/vh_core && dart test     # pure Dart core
cd packages/vh_transcripts && dart test
cd packages/vh_ytdlp && dart test
flutter test --no-pub                # in vh_media, vh_ui and both apps
flutter build apk --debug            # in apps/vidhoist_mobile
flutter build windows --debug        # in apps/vidhoist_desktop
```

After editing an `.arb` file, run `cd packages/vh_ui && flutter gen-l10n`.
Skipping it produces an `undefined_getter` at build time rather than at
edit time. On Windows, `tool/fetch-engine.ps1` puts yt-dlp, ffmpeg and
Deno, at pinned versions with their SHA-256, where the build expects them.

## 6. Testing conventions

- **Every fixed bug leaves a guard test** that fails on the old code.
  The proof is to reintroduce the broken code briefly and watch the test
  fail. Tests are never weakened to let a change through.
- **The device matrix.** `apps/vidhoist_mobile/test/device_matrix.dart`
  and `apps/vidhoist_desktop/test/desktop_matrix.dart` render a widget
  across screen sizes and text scales and catch `RenderFlex overflowed`
  from the engine. Every new screen or sheet passes through
  `expectNoOverflow`.
- **Localisation parity.** `packages/vh_ui/test/arb_parity_test.dart`
  fails if the two `.arb` files diverge in key count, translation or
  placeholders.
- **Real output.** `packages/vh_ytdlp/test/fixtures/` holds what yt-dlp
  really printed on Windows and Android, with media links, addresses and
  local paths replaced. The models' fixtures in `vh_core` are anonymised
  the same way.

## 7. Deeper references

- [`ENGINE.md`](ENGINE.md): the yt-dlp command line, the measurements on
  both platforms, the traps, the storage keys, the backup format and
  short links.
- [`PC-LINK.md`](PC-LINK.md): the phone ↔ computer link: who sees what,
  pairing, the security layers and the protocol.
- [`adr/`](adr/): the decisions that are not reopened without a new one.
