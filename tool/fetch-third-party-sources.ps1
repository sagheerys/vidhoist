# Fetches the source of every GPL and LGPL program the two apps ship, at the
# versions they ship, so each GitHub release can carry it beside the APK and
# the installer. Releasing binaries under those licences means offering
# their source from the same place; a link to someone else's server can
# break, a file attached to the release cannot.
#
#   powershell -File tool/fetch-third-party-sources.ps1
#
# Writes into build\third-party-sources and prints each file's SHA-256.
# When a version below changes (the Android engine library, the yt-dlp pin
# in tool/fetch-engine.ps1, the libmpv build media_kit downloads), change it
# here and in docs/THIRD-PARTY.md together; repo_files_test compares them.

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$out = Join-Path $PSScriptRoot '..\build\third-party-sources'
New-Item -ItemType Directory -Force $out | Out-Null

$sources = @(
  # Android: the engine library, and the programs inside it.
  @{ File = 'youtubedl-android-0.18.1.tar.gz'
     Url  = 'https://github.com/yausername/youtubedl-android/archive/refs/tags/0.18.1.tar.gz' }
  @{ File = 'ffmpeg-7.1.1.tar.xz'
     Url  = 'https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz' }
  @{ File = 'Python-3.12.11.tar.xz'
     Url  = 'https://www.python.org/ftp/python/3.12.11/Python-3.12.11.tar.xz' }
  # Windows: yt-dlp's folder build, and the player library with its FFmpeg.
  @{ File = 'yt-dlp-2026.10.26.tar.gz'
     Url  = 'https://github.com/yt-dlp/yt-dlp/archive/refs/tags/2026.10.26.tar.gz' }
  @{ File = 'mpv-652a1dd907.tar.gz'
     Url  = 'https://github.com/mpv-player/mpv/archive/652a1dd907.tar.gz' }
  @{ File = 'ffmpeg-6.0.tar.xz'
     Url  = 'https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz' }
  # The recipe that built libmpv, at the commit its 2023-09-24 release was
  # made from: the release tag itself holds only a version file.
  @{ File = 'libmpv-win32-video-build-f5a6f879c9b8.tar.gz'
     Url  = 'https://github.com/media-kit/libmpv-win32-video-build/archive/f5a6f879c9b8bef6a73e52c8c0f35e51636c96e5.tar.gz' }
)

foreach ($source in $sources) {
  $target = Join-Path $out $source.File
  if (-not (Test-Path $target)) {
    Write-Host "$($source.File): fetching"
    Invoke-WebRequest -Uri $source.Url -OutFile $target
  }
  $hash = (Get-FileHash $target -Algorithm SHA256).Hash
  Write-Host "$($source.File)  $hash"
}
Write-Host "Attach every file in $out to the release."
