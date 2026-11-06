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
| Machine | i5-9400F, 16 GB, Windows 11 | emulator, API 36.1 x86_64; then a Galaxy S22 Ultra (arm64-v8a, Android 16) on the same home network |

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

11. **The library's first initialisation takes 4.2 s on the phone** (44 s on
    the emulator: Python and ffmpeg are unpacked); later ones take
    0.03–0.13 s. The welcome screen covers the first one, in the background.
12. **The bundled yt-dlp is a year old and fails on YouTube** until it is
    updated. `updateYoutubeDL(STABLE)` took 1.4 s on the phone (15 s on the
    emulator) and brought 2026.10.26. Until the first update `version()`
    returns null, so the app cannot show the bundled version. The
    first run must update before the first download, and the update must
    stay reachable from the engine settings.
13. **QuickJS works for YouTube with no setup**: the library adds
    `--js-runtimes quickjs:<path>` to every request, and yt-dlp's challenge
    scripts (`yt_dlp_ejs` 0.8.0) come in the library's Python. On the phone,
    with `-4`: 1080p (148 MB) 71 s, the H.264 720p selector 77 s, audio to
    M4A 56 s.
14. **On the phone YouTube waits about 50 s before the first byte, every
    time.** Instagram, Facebook and SoundCloud start within 3–6 s on the
    same network, so the wait is QuickJS solving YouTube's challenge
    (verbose run: no retries, the time sits between "Solving JS challenges
    using quickjs" and the formats). A cache folder (`--cache-dir`) does not
    shorten it. The `android_vr` client needs no challenge but offers 360p
    only; `tv` and `web_safari` fail.
15. **`destroyProcessById` stops a download at once**: no Python or ffmpeg
    process left, the folder no longer grows. On the phone it stopped a
    1080p download at 40 s and left no file behind.
16. **What the engine adds per ABI** (arm64-v8a, compressed in the APK):
    ffmpeg 33.8 MB, Python 13.4 MB, yt-dlp 3 MB, QuickJS 0.4 MB, about
    51 MB in all. A release APK per ABI should land around 70 MB; measured
    in batch 4. The library needs `extractNativeLibs="true"` and
    `jniLibs.useLegacyPackaging = true`, and its `*.zip.so` files make
    `llvm-strip` print harmless "not a valid object file" errors.
17. The library asks for Android 7.0 (API 24) at least, the same floor as
    the app, so the minimum stays as it is.
18. **The other platforms work on the phone** with the commands from
    Windows: Instagram 4.5 s, Facebook 3.9 s, SoundCloud 21 s (the original
    upload needs an account; the stream came instead), one TikTok post
    9.2 s. The same TikTok post as on Windows is blocked for a Saudi IP and
    TikTok warns that no impersonation target is available; the X test
    link is dead upstream. A download that goes on with the app swiped
    away needs the foreground service of batch 4 and is measured there.
19. **The fix is in the flow, not the engine: probe once, download from the
    probe.** `--skip-download --write-info-json` (57 s, the challenge
    solved once), then `--load-info-json <file> -f <selector>` started the
    1080p download after 2.6 s and finished it in 32 s. The app already
    probes a link to offer its qualities; keeping that JSON and downloading
    from it removes the second wait. The media links inside expire after
    some hours, so a download queued longer, or resumed the next day,
    probes again. The JSON holds links signed for the requester's IP: it
    stays in the app's cache and is never logged or exported.
20. **Without `-4` the phone waits longer still** (audio: first progress
    after 121 s against 52 s with it; the two video cases did not finish in
    four minutes). Same network as finding 7; `-4` goes on Android too.
21. **The library groups options by name**: `addOption` keeps every value
    but writes each option's values together, in the order the names first
    came, so a second `-f` lands next to the first and the last one wins;
    an option added without its value breaks the command line. The engine
    builds the whole argument list itself (`mt_ytdlp`'s `CommandBuilder`)
    and hands it over with `addCommands`, which keeps the order.

22. **A probe's `-J` output is as good as `--write-info-json` for this**:
    `--load-info-json probe-json.stdout.txt --simulate -f <selector>` picks
    the formats without the network. The six selectors of `mt_ytdlp`'s
    `FormatSelector`, checked that way on the fixture: best 401+258 (AV1
    2160p, AAC), 1080 399+258, 360 396+258, compatible best 299+258 (H.264
    1080p60), compatible 720 298+258 (H.264 720p60), audio 258 (AAC).
23. **The parts' sizes can be printed before the first byte**:
    `--print "video:%(filesize_approx)s %(requested_formats.:.filesize_approx)j"`
    gave `181292478 [150524845, 30767602]` for the compatible 720p pick and
    `30767602 []` for audio alone, so the progress bar is weighted by bytes
    from the start.

## Decisions this asks for

| Question | Recommendation |
|---|---|
| Go on with yt-dlp on both platforms? | **Yes.** Nothing measured blocks it. |
| JavaScript runtime on Windows | Deno, downloaded on first need rather than shipped (94 MB): it solved YouTube's challenge within seconds, where QuickJS took about 50 s on the phone. QuickJS (1.8 MB) only if a Windows measurement shows it fast |
| ffmpeg on Windows | Downloaded on first use, or the shared build; never the 162 MB static one in the installer |
| IPv4 | `-4` by default on both platforms, with a setting to turn it off |
| YouTube's wait on Android | Probe once, keep the info JSON, download from it; the waiting screen says what it is doing during the probe |
| Android first run | Initialise and update the engine on the welcome screen, before the first download |
