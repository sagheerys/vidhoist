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
- Watching from the computer: a tap on a clip in the Computer tab plays it
  on the phone, seeking included, with its transcript as subtitles. Android's
  player opens a proxy on the phone itself (127.0.0.1, a random token per
  run) that fetches through the pinned link, so the computer's certificate
  is still the only one trusted. A copy already on the phone plays instead.
- "Copy to the phone", from a computer clip's menu: the file into the
  phone's media folder with its transcripts beside it as subtitle files,
  indexed as a download is. A copy cut off or stopped leaves nothing.
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
- The computer found again when the router gives it a new address: when
  it does not answer on the home network, the phone asks the network (one
  UDP broadcast, at most twice a minute), and an answer carrying the
  computer's proof moves the link there, kept, with no new pairing. The
  route stays the owner's: never switched to or from Tailscale. The
  computer stays silent to anyone not paired with it, except while it shows
  a pairing code, when "Find on the network" in the typed pairing fills in
  its address.
- Links sent while the computer is away: the add sheet offers it anyway
  ("Away: sent when it is back"), the link waits on the phone (kept through
  restarts, never in a backup, dropped on unpairing) and shows at the top
  of the Computer page with a way to remove it. The phone asks the computer
  every minute while the app runs, and its first answer sends them in
  order; one it refuses stays marked and is not sent again.
- Windows keeps awake while a download runs (the screen still turns off),
  so a link sent from the phone finishes; Settings › Downloads turns it
  off.
- Windows Firewall on the computer's Phone page: when no rule lets VidHoist
  in on the network in use, or one blocks it, a line says so with an Allow
  button that asks Windows for an administrator's permission once and adds
  a rule for private networks only (lifting this app's own blocks there).
  A home network Windows calls Public is named. The uninstaller removes the
  rule.
- The batch screen offers "Save to" the computer as the add sheet does: the
  chosen clips go there one link at a time, in the playlist's order, and
  wait on the phone when it is away.
- Quick download follows the last "Save to": a link goes straight to the
  computer when that was the last choice, with an undo that takes it back
  and opens the sheet; phone-only users see no change.
- The Computer tab counts the downloads running on the computer, and a
  notice in the app says when one is done, with Play. The phone asks only
  while the app is in front and something runs there; no phone
  notification, which would need a service running in the background.
- The Computer tab stays short (owner's request, 2026-11-11): two or more
  downloads there, with the links waiting to be sent, fold into one line
  that opens them in a sheet, as the phone's own downloads do; one keeps
  its card.
- The computer's saved lists on the phone, in the Computer tab: one line
  however many there are, a page of them, and each list's clips that are
  files there, in order, to play all or shuffled. They are read only; the
  phone's own lists are unchanged.
- Delete a clip on the computer from the phone, only once the owner turns
  on "Let the phone delete clips" on Windows (off, and left out of
  backups): it goes to the computer's Recycle Bin after a confirmation
  naming the computer, and a drive with no Recycle Bin is left alone.
- Copy a clip's title: select it in the clip's details on the phone and in
  the player's info sheet, and on the clip's page and in the details panel
  on Windows.
- YouTube clips waiting their turn in the download queue show their cover
  instead of a blank, until yt-dlp brings its own.
- A slimmer video bar on the phone: under the video and in full screen the
  time and buttons sit in one row, with a thin progress bar along the
  bottom edge, so less of the picture and its subtitles is covered.
- On Windows, the floating window can be made larger: drag its edges to
  grow the picture, keeping its shape, up to half the screen.
- On Windows, the search in the title bar grows into the search in its own
  place instead of a separate box appearing at the top of the window.
- On Windows, "Open in another player…" in a clip's right-click menu opens
  it in VLC or any player installed.
- Sharing several links to the phone at once asks first ("Add 7 links?"),
  and takes at most 50 from one share; a single link works as before.
- A phone reinstalled with VidHoist downloads but no settings offers, once,
  to choose a backup with the system's file picker: Android hides the old
  install's backup files from the new one, so the restore it offered never
  appeared.

### Fixed
- **The last clip in a batch download could not be unticked** on the
  phone: the "Download selected" button covered its checkbox. The list now
  scrolls clear of it, and the followed-channels list clear of its button.
- Leaving full screen stands the player upright at once, even while the
  phone is still held sideways; turning it sideways opens full screen again
  once it has been held upright.
- A pause before the share menu with a large file: a line now says the
  share menu is being opened instead of the app seeming to freeze.
- Download errors cut short: tap a failed download's reason to read all of
  it, on both apps.
- On Windows, library statistics no longer flicker and jump to the top each
  time the library refreshes.
- Pictures in "What's new" showed as a stray `!` and their caption; they
  are left out of the sheet.
- Confirmation dialogs at the largest text size scroll their words instead
  of pushing the buttons off a small screen.
- Long subtitle files are read off the main thread; subtitle files with
  broken timings are put in order or skipped, and transcript search stays
  quick on a file whose lines all share one time.
- On Windows, the "Start with Windows" entry quotes the program's path, and
  an unquoted entry left by an earlier version is written again.
- **On Windows, an uninstall that deleted the app's data took the backups
  with it** (owner's report, 2026-11-12): the library list and the
  followed channels were gone and no backup was left to restore. Backups
  now live in `Downloads\VidHoist\Backups`, beside the downloads, as the
  phone's do; those in the old place are carried over at the next start.
  The uninstaller's question now names everything it deletes and says the
  backups stay.
- On Windows, a backup of the computer itself, chosen or dropped, is
  restored whole after asking (library and channels included). It used to
  be merged like a phone's, which brought back the playlists alone.
- On Windows, the first start after an install offers the newest backup
  when there is one, before the welcome: restored, the library, followed
  channels, playlists, tags and settings come back in one answer. No
  automatic backup is written until that first start is settled, so an
  empty install never becomes the newest copy.
- On Windows, the saved transcripts are kept beside the backups
  (`Backups\transcripts.json`) and come back with every restore; they are
  files of their own, which the backup itself never carried.
- Settings › Transcripts on Windows no longer has an Import and Export of
  its own beside Backup's: it took a computer's full backup too and offered
  to restore everything. Transcripts now move to and from a phone under
  Backup alone, and the pane links there ("Open Backup"). Backup's import is
  titled for what it takes ("Import a backup or transcripts…"), and its
  "Export for the phone" carries the transcripts. "Delete all" also removes
  the copy beside the backups, so a later restore no longer brings back
  what was deleted.
- Settings › Backup on Windows can put back in the library the clips
  already in the downloads folder ("Clips already in the folder"): after a
  reinstall the files were all there, but unlisted. A clip's link comes from
  the `.info.json` beside it, a playlist that names the file, or the YouTube
  id in its name; a file whose link cannot be told is left out and counted.
- The Windows installer tells Explorer the icons changed, so a desktop
  shortcut shows the new mark too, not only the Start menu.
- The player's "Next" list, the mini player and the media notification
  show the covers the computer keeps for its clips (owner's report,
  2026-11-10): they come through the phone's local proxy.
- The add-link button no longer shows over the menu of a clip in the
  Computer tab (owner's report, 2026-11-10): every sheet now opens above
  the whole app, where the button knows to hide.
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
- A new mark: a strip of film folded into the letter V, its front arm
  carrying four perforations, the back arm in the accent, with a clear gap
  along the fold. It replaces the window with the download arrow on the
  phone's launcher (themed icon included), the Windows icon, the tray, the
  title bar, About, the installer and the brand files. Still generated by
  `tool/icons/vidhoist_kit.py`; the boards the owner chose from are in
  `docs/design/mockups-2026-11-11-logo*`.
- On the phone, Settings › Accounts puts each site's sign-in at the end of
  its row, in the soft accent, so the six sites and "clear all" fit one
  screen; the button drops under the name only when the row is too narrow.
  The update sheet leads with the version as one large figure, and while it
  downloads shows the percent and how much of the size is in.
- On the phone, Settings › Download engine shows yt-dlp's version as the
  page's one large figure, in a card that says how it stands ("Updated"
  while the last update worked and is within the app's weekly round,
  "Update failed" when it did not). The update and the repair are two
  buttons of one shape, full width, and the repair's explanation sits under
  the button it explains.
- Deleting a clip on Windows puts its file in the Recycle Bin instead of
  deleting it for good, so a slip can be undone; on a drive with no
  Recycle Bin it is deleted as before.
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

### Security
- **Updates are checked against GitHub's own fingerprint.** The downloaded
  APK or Windows installer must match the SHA-256 GitHub records for it,
  or it is not installed. Both apps.
- Answers read from the network stop at a ceiling (5 MB for pages and
  release notes, more for YouTube's playlist answers and the paired
  computer's), so an endless answer cannot fill the device's memory; a
  subtitle file over 5 MB is skipped.
- Shared logs hide more: IPv6 addresses, `C:/` paths written with either
  slash, and host names in the Windows player's lines.

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
