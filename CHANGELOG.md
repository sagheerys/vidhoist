# Changelog

All notable changes to VidHoist. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- "Download on the computer", off until turned on: on Windows, Settings ›
  Phone receives from a paired phone over the home network; on the phone,
  Settings › Computer pairs with it (a code shown on the computer, then four
  digits both screens show, which the owner compares before allowing it).
  Once paired, a Computer tab shows what the computer downloads and its
  library, and the add sheet offers to send a single link there while the
  computer answers. HTTPS with the computer's own certificate pinned on the
  phone; every path answers an empty 404 without a paired phone's key. A
  phone that never pairs sees no change. See docs/PC-LINK.md.
- Pairing with the computer by QR code: Windows shows one beside the code,
  carrying the computer's addresses, the code and its certificate's
  fingerprint; on the phone, "Scan the code" opens Android's camera
  (zxing, open source, no Google Play services), tries the addresses and
  pairs on the first that answers, with the certificate pinned before the
  code is sent. Typing the address and code stays as a fallback.
- Settings › Computer › Connect through, on the phone: the owner picks the
  home network or Tailscale, from the addresses the computer reports with
  every answer (no new pairing needed). The phone never switches on its
  own; the Computer page shows the route in use and, when the computer does
  not answer, points to Tailscale.
- Design brief (`docs/blueprint/DESIGN-BRIEF.md`): the identity in one
  table, how a screen is drawn before it is coded, and the approval log.
  Mockups live in `docs/design/` and are built from the icon set and from
  `tool/icons/vh_palette.py`, which reads `palette.dart`; the first set draws
  "download on the PC" on the phone.
- A warning beside the sign-ins (Accounts on the phone, Cookies on
  Windows): better a secondary account, since heavy downloading can get
  an account restricted by the site for a while.
- "Repair the engine", in the engine settings of both apps, for downloads
  failing across sites when an update did not help: it clears what yt-dlp
  saved between runs and puts back a clean, current copy, even when the
  one there claims the right version. Files and settings stay; it waits
  until nothing downloads.
- Settings › Downloads › Save to, on the phone: downloads go to the
  phone's storage or to a memory card (Android 11 and later). The library
  shows both, clips already downloaded stay where they are, and a chosen
  card that is out sends the download to the phone instead of failing it.
  The phone's folder is renamed `Download/VidHoist`, like the app, where
  Android allows it; where it refuses, the app keeps the old spelling it
  finds, so the library, favourites, titles and covers stay as they were.
- Settings › Accounts on the phone: a sign-in to YouTube, Instagram,
  Facebook, TikTok, X or Vimeo on the site's own page inside the app, for
  the clips a site refuses without one (age checks, "confirm you're not a
  bot", posts for followers). The sign-in stays on the phone, in the
  app's private folder, where yt-dlp reads it for every download; a
  download that failed for want of it offers the sign-in on its card, and
  each site signs out from its row.
- When a site moves on without yt-dlp and a download fails the way an
  outdated build fails (a page it can no longer read, a challenge it
  cannot solve, a 403), the engine updates itself and the download tries
  once more, on the phone and on Windows, without a word. Attempts are
  kept hours apart, and one serves every download failing at the same
  time.
- Windows brings yt-dlp up to date once a week by itself, a little after
  the start and while nothing is downloading, as the phone has done; the
  button in Settings › Engine stays for "now".
- Following channels on Windows, on the computer itself. Each new video of
  a followed channel downloads into the library at the quality, in the
  folder and through the title filter chosen for it, while VidHoist is open
  or in the tray; a check missed while it was closed is made a little after
  it opens. What was on the channel before following is not downloaded. A
  YouTube channel's link follows its videos, not its Shorts or live
  streams, and a stream on the air arrives once it is over.
- A channel can be followed from the link of any of its videos, and
  "Channels in your library" fills that in with the newest one there:
  the follow dialog used to open with an empty link.
- Following channels on the phone, from Settings › Channels: follow by a
  link (of a channel, a playlist or one of its videos), pause, check now,
  change how often and the title filter, unfollow. New videos download at
  the quality chosen when following, while VidHoist is open or in the
  background, and what came while it was closed downloads when it opens.
  The channels are in the backup.
- The phone's channels page shows each channel as a card: its picture, how
  many subscribe, how often it is checked and at what quality, and how its
  last check went. A channel's sheet shows
  its banner, opens the channel itself ("Open channel"), and keeps
  unfollowing apart from checking, pausing and editing.

### Fixed
- Download on the computer, from its first try on real devices: the phone's
  pairing form has the port in a field of its own (the number pad has no
  colon, and the port is rarely needed); Windows shows the home network's
  address first, named by its adapter, Tailscale's apart, and the adapters
  other programs add (VirtualBox, WSL…) folded away; the settings list
  counts a phone paired after it was opened instead of "No phone"; a clip
  tapped in the computer's library says watching comes later; "0 seconds
  ago" reads "just now". The link also works over Tailscale, and the texts
  say so.
- The download card no longer runs past its edge on the narrowest phone
  when a speed shows beside the percentage: the speed yields first.
- A channel's picture and banner are kept on the phone: they show with no
  network and are no longer fetched at each visit; unfollowing deletes
  them, and following again fetches them anew.
- A channel check with no network (the phone waking offline) no longer
  shows yt-dlp's error in red: the card keeps its last good check, and the
  channel is tried again a few minutes later. Any other failure says so in
  a calm sentence, with yt-dlp's words only in the channel's sheet.
- Android's "No address associated with host" now counts as a network
  failure everywhere, not as an unknown error.
- The phone's About screen links to Vidhoist's own repository and issues,
  not to the project it came from.
- On Windows, a crash note is written where the app reads it
  (`%LOCALAPPDATA%\Vidhoist\logs`); it went to an old folder before, so
  a crash was never reported on the next launch.
- On Windows, "What's new" and the update notes now leave out what only
  the phone app has; the filter never matched the Windows app before.

### Changed
- The app's name is written VidHoist, with its capital H, wherever it
  is shown: under the icon, in the window title, in the installer and
  in every text. Folders, ids and release files keep their spelling,
  so nothing moves and updates still find each other.
- Channels are always in the sidebar and in Settings; the "later features"
  switch now hides Sync alone.
- Nothing of Vidhoist is left in the apps: no Vidhoist credit in About, no
  mention of Vidhoist or a server in the texts or the Windows installer, and
  the phone's notification channels now carry Vidhoist's name (the old
  ones are removed, so Android's settings list each kind once).
- VidHoist no longer reads Vidhoist's backups: the old encrypted formats
  (MTBACKUP1, MTSBACKUP1, MTF1), their key, and Vidhoist Lite's playlists of
  file paths are gone. Backups are now written under Vidhoist's own name,
  and those written by 1.0.0 still import.
- The channel pages and the title filter no longer speak of a server, and
  the title filter ignores capitals.
- The Windows library no longer marks every clip "offline": every clip is
  a file on this computer. The "Offline" place in the sidebar, the command
  palette and the smart lists went with it, since it held the same clips
  as "All".

### Removed
- Sync between the phone and Windows, which waited behind the
  "later features" switch in Settings › Engine and never reached
  the phone. Each device keeps its own library, so there was little
  for it to carry; a backup moves channels, lists, tags and settings
  from one device to the other.

## [1.0.0] - 2026-11-07

### Added
- The project. VidHoist starts from
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
- `packages/vh_ytdlp`: the yt-dlp command lines (format selectors, IPv4 by
  default, downloading from a probe's info JSON), and reading what yt-dlp
  prints back: progress, the parts of a merged download, the finished file,
  the info JSON, classified errors and the engine's version. Pure Dart, not
  yet used by the apps.
- In `vh_core`, beside the server engine: `DownloadBackend` (yt-dlp on the
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
- The transcript on the phone: the player's "Transcript" button, or a long
  press on CC, opens the clip's subtitles line by line, the one being said lit
  and followed, with a search that ignores hamza and vowel marks, steps
  between results, a switch between languages, and a tap on a line to play
  from there.
- The subtitles' size (small, medium, large, larger) and background (dark,
  light, none) on the phone, in the playback settings and under a long press
  on CC, kept between runs.

### Changed
- Version 1.0.0 in both apps (build 16, above the parent's 15).
- The README says 1.0.0 and shows the Android app.
- Package and application identifiers: `apps/vidhoist_mobile`
  (`com.yasir.vidhoist`), `apps/vidhoist_desktop` (`Vidhoist`,
  `%APPDATA%\Vidhoist`, link scheme `vidhoist://`, a new installer AppId).
  The download folder is `Download/Vidhoist`. Self-update reads
  `sagheerys/vidhoist` releases.
- User-facing strings that named Vidhoist, Lite, Super or Ember now say
  VidHoist, in English and Arabic alike. Strings about the server are kept
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
- The sync subfolder is `Vidhoist Sync`, so VidHoist and Vidhoist never share
  one library when pointed at the same synced folder.
- Nothing is saved beside a video but its subtitles: no `.info.json` and no
  `.jpg`. The cover goes inside the file, where it outlives the site
  deleting it; videos are saved as MP4 for that. Windows now reads that
  cover before taking a frame of the video.
- By day, white cards stand on a soft stone ground (`#F2F1EE`) instead of a
  white one, which glared and left the cards only a hairline to stand on.
- Windows hides Channels and Sync unless they are switched on in
  Settings › Engine. The taskbar badge is blue. Channels say they come in a
  later version: following needs a scheduler on this computer (1.2).
- Windows: deleting a clip, from its menu, its page or a selection, deletes
  its file on this computer, its record, its tags and its lines in the
  lists. "Show in Explorer when done" now opens on each finished download.
  Settings › Folders keeps the download folder alone; the offline folder,
  "ask every time" and the server's folders went with the copies.
- Strings still shown that named the server say what happens now (a
  network error, a login a site wants, the folder help, the Vidhoist credit),
  in English and Arabic alike.
- The transcript backfill reads yt-dlp's errors with the download engine's
  own `ErrorClassifier`, so the two never disagree about a line.

### Removed
- **The Vidhoist server layer, in both apps and every package** (batch 6 of
  phase 1). In `vh_core`: the API client and everything around it (address
  switching, LAN probe, live channel, image headers, server reasons), the
  server download pipeline (add, poll, pull, delete) with its pending pulls,
  sweeper, transfer and trashcan probe, the server's folders and version,
  and the Vidhoist release check. In `vh_transcripts`: fetching captions
  before a clip and reading subtitles beside it on the server, and the
  command-line backfill that read a server's list. On the phone: the
  server fields and status card, the "server keeps files" notice,
  `flutter_background` and the cleartext exception for a LAN server. On
  Windows: the first-run server setup, Addresses, the server line and
  version, offline copies and "then download it to this computer", the
  server's watch on the library, arrival notices for channels, and the
  debug lab server. `docs/legacy/` (the server contract and its setup
  guide) went too; what still applies is in `docs/ENGINE.md`.
- 164 strings in each language that only the server used.

### Fixed
- The phone offered "AR" twice in the subtitles' language switch for a clip
  spoken in Arabic: YouTube sends the same file as `ar` and `ar-orig`. A
  copy of another language is now read as one.
- The download counter jumped from 0 to 100%: the subtitle files, fetched
  before the video, were counted as its parts. It now moves with the video
  alone, on both apps.
- Subtitles asked for every machine translation into Arabic and English
  (`ar-fr-FR`…), which YouTube can refuse; now the language, its original
  track and its regions.
- Windows showed two subtitles at once: the app's, and one mpv loaded by
  itself from the `.vtt` beside the video, over the seek bar.
- Windows: a finished video whose title had a `/` never reached the library
  (the path read back lost the `⧸` yt-dlp writes for it), and a download
  restored at launch went to the default folder instead of the chosen one.
- Windows offered "Delete from server" on every clip, did nothing, and said
  it was deleted. It deletes the file now.
- Windows looked for missing covers and read clips' lengths only with a
  server set up, so a library downloaded here never had them; both now read
  the files on this computer.
- Self-update would never have offered a VidHoist release: the phone looked
  for files named "lite" and Windows for "ember", and Windows saved the
  installer as `Vidhoist-Ember-…`. Both now look for `Vidhoist` and tell the
  APK from the installer by the extension.
- The phone still saved into `Download/Vidhoist_Lite`; it now uses
  `Download/Vidhoist`, as the identity said.

### Known, deliberately
- `vh_media` keeps its streaming endpoint (always `none`) and the library's
  "on the server" fields, read from records that still carry the shape of
  Vidhoist's history; neither streams or reaches a server. `HistoryItem` and
  `ServerPath` stay for that shape.
