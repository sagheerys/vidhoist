# Changelog

All notable changes to VidHoist. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Android: a + in a playlist opens the library to choose clips from, with
  search and the type; what the playlist holds is marked, the rest is
  added in the order ticked, with an undo.
- Android: the mini player in Settings, as a small tab at the edge where
  lines start; a tap opens the usual bar, which folds back after a few
  seconds. It hides while the keyboard is open.
- Both apps: the update sheet and "what's new" in the reader's language.
  A release may carry `release-notes.json` with each app's notes in every
  language; without it the release page is shown as before.

### Fixed
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
