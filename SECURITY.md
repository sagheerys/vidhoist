# Security

## Reporting a vulnerability

**Do not open a public issue for a security problem.**

Use GitHub's private reporting instead: go to the repository's **Security** tab
and choose **Report a vulnerability**. That opens a thread only you and the
maintainer can read, and it stays private until a fix exists.

Please include what you did, what happened, and the version from
**Settings → About**. A proof of concept is welcome and never required.

You should get a first reply within a week. If a report turns out to be real, a
fixed release follows, and you are credited in the release notes unless you
would rather not be.

## What is in scope

VidHoist downloads with yt-dlp on the device; there is no server. The
interesting surface is small and worth naming:

- **The engine's command line.** Links and names reach yt-dlp as separate
  arguments, never through a shell, and its output template keeps every file
  inside the download folder. A link or a title that runs something, or
  writes outside that folder, is a real issue.
- **Cookies.** A cookies file or a browser's cookies are passed to yt-dlp and
  to nothing else. One that leaks into a log, a backup or another request is
  a real issue.
- **The backup file.** It is deliberately plain text and deliberately holds no
  secret: no password, no username, and credentials embedded in a URL are
  stripped. A secret found inside one is a real issue.
- **The self-update path.** The downloaded APK is checked for the ZIP magic
  bytes and for the size the release announced, then handed to the system
  installer as a `content://` URI. Anything that gets a different file
  installed is a real issue.
- **The diagnostic log.** It is scrubbed before it can be shared, of
  credentials, URLs, paths and addresses. A secret surviving the scrub is a
  real issue.

## What is out of scope

- **yt-dlp**, ffmpeg and Deno themselves, and the sites they download from.
  Report those upstream.
- **An attacker who already has your unlocked phone.** Android's own protection
  is the boundary; the apps do not add one.

## Supported versions

The newest release is the one that gets fixes. This is a small project, so
older versions are not maintained in parallel.
