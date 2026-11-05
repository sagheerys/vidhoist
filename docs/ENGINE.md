# The download engine: yt-dlp on Windows and Android

Measured in batch 1 of the phase 1 plan (2026-11-05/06), before any engine
code was written. This file is the reference for the command lines, the
measurements and the traps; `docs/legacy/` goes once it covers everything.
Raw stdout and stderr of the Windows runs are kept as fixtures in
`packages/mt_ytdlp/test/fixtures/windows/` (media links, the requester's IP
and local paths replaced).

## Versions measured

| Part | Windows | Android |
|---|---|---|
| yt-dlp | 2026.10.26 (`yt-dlp.exe` and `yt-dlp_win.zip`) | 2026.10.26 after an in-app update; the library ships 2025.11.12 |
| Runner | the PyInstaller build itself | `io.github.junkfood02.youtubedl-android` 0.18.1 (`library` + `ffmpeg`), Python bundled |
| ffmpeg | yt-dlp/FFmpeg-Builds master, win64 GPL static | bundled with the library |
| JavaScript for YouTube | Deno 2.9.8, and none | QuickJS bundled (`libqjs.so`), passed by the library on every request |
| Machine | i5-9400F, 16 GB, Windows 11 | emulator, API 36.1 x86_64 (no phone attached) |

## The command line that works

```
yt-dlp --no-config -4 --newline --progress --no-colors
  --progress-template "download:[vh] %(progress.status)s %(progress.downloaded_bytes)s
    %(progress.total_bytes)s %(progress.total_bytes_estimate)s %(progress.speed)s
    %(progress.eta)s %(progress.fragment_index)s %(progress.fragment_count)s"
  --print "after_move:[vh-file] %(filepath)s"
  -P <folder> -o "%(title).80B [%(id)s].%(ext)s"
  --windows-filenames --ffmpeg-location <dir>      (Windows only)
  --js-runtimes deno:<path>                        (Windows; Android adds quickjs itself)
  -f <selector from REPORT §5.1> <url>
```

- **`--print` silences everything else**, progress included. `--progress`
  brings the progress lines back; without it the app sees nothing until the
  file is done.
- The template's fields arrive as plain numbers or `NA`. `total_bytes` is
  known for a single stream; a merge of video and audio reports each stream
  in turn, so progress restarts from zero for the audio part.
- `[vh-file]` comes once per finished file, after any merge or conversion,
  with the final path. That line, not a guess from the template, is what the
  library records.

## Findings

### Both platforms

1. **YouTube works on both, at 1080p and above, including the H.264
   compatible selector and audio extraction.** Without a JavaScript runtime
   it still works on Windows today, with a deprecation warning and fewer
   formats (49 against 57 for the same clip; the 1080p60 picture is there,
   and the selector picked Opus audio instead of AAC). yt-dlp says this path
   is going away, so the apps must carry a runtime.
2. **Resume works as documented.** A download stopped part-way leaves
   `<name>.part`; running the same command again continued from byte
   20,273,448 of 87,293,859 and finished. A download stopped before its
   first byte leaves nothing, so "resume" then means "start again".
3. **Errors are one line on stderr starting with `ERROR:`**, extractor in
   brackets, then the reason: `This video is unavailable`, `Unable to
   download webpage: HTTP Error 404`, `Your IP address is blocked from
   accessing this post` (TikTok, regional). Fixtures `err-*`, `tiktok*`, `x`.
4. Platforms tried on Windows with yt-dlp's own extractor test links:
   YouTube, Instagram (a reel, no login), Facebook, SoundCloud and one
   TikTok post downloaded; two TikTok posts are blocked for a Saudi IP; the
   X test link is dead upstream.

### Windows

5. **Stopping yt-dlp means stopping its process tree.** `yt-dlp.exe` (one
   file) starts a second `yt-dlp.exe`, and Deno runs as a child of either.
   Dart's `Process.kill` ends only the first: in the measurement the
   download went on and wrote 9.6 MB more in the next five seconds. Killing
   the tree (`taskkill /PID <pid> /T /F`, or a Job Object with
   kill-on-close, which also covers the app itself crashing) stops it at
   once.
6. **Use the folder build, `yt-dlp_win.zip`.** It starts in about 0.54 s
   against 1.75 s for the one-file build, and runs as a single process
   (Deno still a child). 40 MB unpacked against 22.5 MB.
7. **A broken IPv6 route stalls every download by about 20 seconds, then
   crawls.** On this network the first byte came after 26.3 s without `-4`
   and after 5.3 s with it, and the whole 83 MB file arrived within the next
   10 s. The earlier "1 MB/s" readings were this, not YouTube throttling.
   Some users will have the same network; `-4` is passed by default above,
   and a setting or an automatic retry over IPv6 is needed for the networks
   that only have IPv6.
8. **Sizes beside the app:** yt-dlp folder 40 MB, Deno 94 MB, ffmpeg static
   GPL 162 MB (with ffprobe, 324 MB). The static ffmpeg is too large to ship
   as is; the shared build (86 MB zipped) or a download on first use is the
   choice to make.
9. **Dart reads the progress line by line** from `Process.start` (first line
   about 6 s after the start, then one per update).
10. Not measured: whether a console window flashes when the GUI app starts
    `yt-dlp.exe` (needs a local Windows build, which waits on the C++ tools),
    and QuickJS as the runtime on Windows (1.8 MB instead of Deno's 94; the
    download of `qjs.exe` was refused by the session's safety check and is
    left to the owner).

### Android

11. **The library's first initialisation takes about 44 s** on the emulator
    (Python and ffmpeg are unpacked); later ones take 0.35–1.4 s. The
    welcome screen has to cover the first one, in the background.
12. **The bundled yt-dlp is a year old and fails on YouTube** until it is
    updated. `updateYoutubeDL(STABLE)` took 15 s and brought 2026.10.26. The
    first run must update before the first download, and the update must
    stay reachable from the engine settings.
13. **QuickJS works for YouTube with no setup**: the library adds
    `--js-runtimes quickjs:<path>` to every request. 1080p (148 MB) took
    56 s, the H.264 720p selector 64 s, audio to M4A 34 s.
14. **The first progress arrives 25–27 s after the start** on the emulator,
    against about 5 s on Windows with Deno. The emulator and QuickJS's
    slower challenge solving are the likely causes; it must be measured on
    a phone before the waiting screen is designed.
15. **`destroyProcessById` stops a download at once**: no Python or ffmpeg
    process left, the folder no longer grows.
16. **What the engine adds per ABI** (arm64-v8a, compressed in the APK):
    ffmpeg 33.8 MB, Python 13.4 MB, yt-dlp 3 MB, QuickJS 0.4 MB, about
    51 MB in all. A release APK per ABI should land around 70 MB; measured
    in batch 4. The library needs `extractNativeLibs="true"` and
    `jniLibs.useLegacyPackaging = true`, and its `*.zip.so` files make
    `llvm-strip` print harmless "not a valid object file" errors.
17. The library asks for Android 7.0 (API 24) at least, the same floor as
    the app, so the minimum stays as it is.
18. **Not measured:** Instagram, TikTok, Facebook and SoundCloud on Android.
    The emulator's network here resolves `facebook.com` to 127.0.0.1 and
    refuses other hosts, and with public DNS it resolves nothing; the
    commands are the ones that worked on Windows. Left to the owner's
    phone, with a download in the background and the app swiped away.

## Decisions this asks for

| Question | Recommendation |
|---|---|
| Go on with yt-dlp on both platforms? | **Yes.** Nothing measured blocks it. |
| JavaScript runtime on Windows | QuickJS if it holds on Windows (1.8 MB); otherwise Deno downloaded on first need rather than shipped (94 MB) |
| ffmpeg on Windows | Downloaded on first use, or the shared build; never the 162 MB static one in the installer |
| IPv4 | `-4` by default, with a setting to turn it off |
| Android first run | Initialise and update the engine on the welcome screen, before the first download |
