# Changelog

All notable changes to VidHoist. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/).

## [1.2.0] - 2026-11-26

### Added
- Android: a + in a playlist opens the library to choose clips from, with
  search and the type; what the playlist holds is marked, the rest is
  added in the order ticked, with an undo.
- Both apps: the update sheet and "what's new" in the reader's language.
  A release may carry `release-notes.json` with each app's notes in every
  language; without it the release page is shown as before.
- Windows: a clip being downloaded stands in the library at once, first,
  with its progress and what is happening to it; a click opens the
  downloads.
- Both apps: after the third download that finishes, the app asks once
  whether it is liked, with a star on GitHub and a way to suggest an idea
  or report a problem; "Maybe later" asks once more, twenty downloads and
  thirty days on, and "Don't show this again" never. A sheet on the phone,
  a small card in the library's corner on Windows. Nothing is sent: the
  count stays on the device.
- Both apps: About links to the project's Telegram channel, where releases
  are announced.
- Windows: closing the app while downloads are going asks first, with the
  clip and how far it has come; "Keep downloading" keeps it open. They go
  on at the next start either way. Not asked when the close goes to the
  tray or nothing is downloading.

### Changed
- Windows: an empty library asks for the first link in place, and shows
  its filters and layouts only once it holds a clip.
- Windows: on a clip's page the side panel shows that clip's transcript
  and details even while another clip plays; a click on a line starts it
  there. The reading room folds the panel, whose transcript the article
  already is.
- Windows: search has one way in, the title bar's box (or Ctrl+K); the
  sidebar's Search entry is gone, and saved searches stay in the sidebar.
  Before a word is typed the search offers the saved searches and the
  clips played last; commands are after `>`.
- Windows: the library's order is written out ("Sort by: Newest"), the
  three layouts sit in one frame, and the statistics are named beside the
  count.
- Windows: the controls over a paused picture fade like those of a playing
  one and come back with the pointer; in full screen they stay while
  paused.
- Windows: on a wide window the library's table gives the channel its own
  column and holds the title to a readable width, the heart staying at the
  row's edge; when room runs short the source column goes first, so a
  large font no longer cuts the titles.
- Windows: on a large screen the grid's covers grow with the window, six
  to a row at 1920 instead of eight small ones.
- Windows: with a large font the statistics keep their figures whole and
  shorten the bar instead.

### Fixed
- Both apps: a cancelled download left its unfinished files in the
  download folder. They are now deleted when it is cancelled (a paused one
  keeps them, to go on later), and Windows also clears old ones at start,
  as Android did.
- Windows: a settings file cut short by a power cut or a crash stopped the
  app from starting. The app now keeps a last good copy and puts it back,
  keeping the damaged file aside.
- Android: the notification permission was asked the moment the app
  opened; it is now asked at the first download.
- Android: back during a selection in the library left the app and lost
  the selection; it now undoes the selection first.
- Android: with three-button navigation the last row of four sheets (a
  channel's actions, a computer clip's actions, the subtitle options, the
  computer's downloads) sat under the buttons.
- Android: in full screen held sideways, the top bar and the seek bar could
  sit under a notch or a camera hole.
- Arabic: the copied-link banner kept its wider margin on the wrong side,
  and two arrows (back in full-screen video, the update row) pointed the
  wrong way.
- Windows: the app icon gains its 128-pixel size.
- Windows: "Sort by" was cut in a narrow window in Arabic with room to
  spare beside it.
- Windows: a download still without its title showed its whole link in
  the library; it is called by its site until the title comes.
- Android: a tap on "download complete" only lit the clip. It now closes
  what is open above the tabs, shows the library, undoes a search or a
  filter that hides the clip, and scrolls to it; a tap that started the
  app is no longer lost, and a clip deleted since says so.
- Android: a clip the app could play but not delete ("Cannot delete file
  ... No such file or directory"). Android forgets that a download belongs
  to the app once the app's data is cleared or the app is installed again,
  and then refuses its deletes; such clips are now deleted through
  Android's own confirmation dialog.
- Covers from Facebook, Instagram and TikTok that went blank after a few
  days: their addresses expire, and are now replaced by a frame of the
  clip's own file. A run of expired covers no longer stops the others from
  being kept on the device, so covers show without a connection.

## [1.1.0] - 2026-11-20

The first public release of VidHoist, for Android and Windows, in twelve
languages: English, Arabic, Spanish, Portuguese (Brazil), French, German,
Turkish, Russian, Indonesian, Persian, Urdu and Hindi, each following the
device's language unless another is chosen. Everything here is new.

### Downloading
- yt-dlp built into the app: Python, yt-dlp and ffmpeg inside the Android
  app; yt-dlp with the Windows installer, ffmpeg and Deno fetched on first
  need and checked against a pinned SHA-256.
- A link pasted, noticed on the clipboard, or shared to the phone; quick
  download at the usual quality, or the full sheet to choose; several
  links at once, and a playlist as a list to tick.
- Best, a ceiling from 1080p to 360p, or audio only (M4A, MP3 or as the
  site sends it); MP4 with the cover inside the file; "Best playback
  compatibility" for phones that stutter on AV1.
- Only a part of the video, from one time to another, kept as its own clip.
- Subtitles in the languages chosen, beside the clip and optionally inside
  the video file.
- Sign-ins to YouTube, Instagram, Facebook, TikTok, X and Vimeo inside the
  phone app, a `cookies.txt` on both, and a browser's cookies on Windows.
- Pause and resume, downloads that carry on in the background, a speed
  limit, segmented streams, Wi-Fi only on the phone, and a memory card as
  the phone's download folder.
- The engine updates itself weekly and after a failure that looks like an
  outdated build, then tries the download once more; "Repair the engine"
  puts back a clean copy.

### The library and the players
- The library of what was downloaded: video, audio and shorts, sorting and
  filters, favourites, tags, playlists and smart playlists.
- Search by title and by **what was said** inside the clips, the word lit
  in each moment, a tap playing from that second; Arabic is found whatever
  marks were typed.
- The video player: subtitles at the size and background chosen, the
  transcript under the video following along, continue as audio, picture
  in picture; a reels player for shorts.
- The music player: background playback with notification and lock-screen
  controls, a queue, repeat, shuffle and speed, and the line being said.
- Layouts of their own on tablets.

### Download on the computer
- Pair the phone with Windows by a QR code, or a code and four digits; send
  a link to the computer, follow its downloads, play its library on the
  phone with transcripts, copy a clip to the phone, and move one to the
  computer's Recycle Bin when allowed there.
- Links wait on the phone while the computer is away. The home network or
  Tailscale, chosen by the user; HTTPS with the computer's own certificate
  pinned on the phone. See [docs/PC-LINK.md](docs/PC-LINK.md).

### Windows
- The library as a grid, a table or a compact list; Ctrl+K over titles,
  what was said and commands.
- The reading room (a transcript as an article, exported as PDF, Markdown
  or SRT) and the listening room.
- Following channels, on Windows and on the phone: each new video downloads
  by itself at the quality, in the folder and through the title filter
  chosen. The phone can also check while it is closed, about every six
  hours, and say what is new.
- A small video window, dragging a clip out to Explorer, another player,
  the tray, starting with Windows, the Recycle Bin for deleted clips, and
  keyboard shortcuts throughout.

### Privacy, backups and updates
- No account, no ads, no tracking, and no server of the project's own.
- Plain JSON backups with no secret, the last seven kept beside the
  downloads; a phone's backup restores on Windows and the other way round.
- Self-update from this repository's releases, installed only when the file
  matches the SHA-256 GitHub records for it, and refused when there is none.
- Site sign-ins stay on the phone: Android's cloud backup and transfer to a
  new phone leave them out.
- A diagnostic log scrubbed of links, paths, addresses and credentials
  before it is shared.
