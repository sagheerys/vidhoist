# Fetches the engine the Windows app runs: yt-dlp's folder build, and on
# request ffmpeg and Deno, at pinned versions checked against their SHA-256.
#
#   powershell -File tool/fetch-engine.ps1     yt-dlp into apps/vidhoist_desktop/tools,
#                                              which the installer ships ([Files])
#   powershell -File tool/fetch-engine.ps1 -All -Into "$env:APPDATA\Vidhoist\engine"
#                                              the whole engine where the app looks
#                                              first, for a developer's machine
#
# The installer ships yt-dlp only: ffmpeg (115 MB zipped) and Deno (43 MB)
# are fetched by the app on first need, with the same pins as
# apps/vidhoist_desktop/lib/platform/engine_pins.dart. Change both together;
# a test holds them to each other.

param(
  [string]$Into = (Join-Path $PSScriptRoot '..\apps\vidhoist_desktop\tools'),
  [switch]$All
)

$ErrorActionPreference = 'Stop'

$pins = @(
  @{ Name = 'yt-dlp'; Version = '2026.10.26'
     Url = 'https://github.com/yt-dlp/yt-dlp/releases/download/2026.10.26/yt-dlp_win.zip'
     Sha256 = 'fd51b212cf8380c7a52ee08c0d6be7f3c59b2f2c832eaf7b45acfae6eab57419'
     Keep = @('*') },
  @{ Name = 'ffmpeg'; Version = '9.0.2'
     Url = 'https://github.com/GyanD/codexffmpeg/releases/download/9.0.2/ffmpeg-9.0.2-essentials_build.zip'
     Sha256 = '60f467265b1e312373dbcd92200c2618a74850f98d3d078e94296bb3fa2047ba'
     Keep = @('ffmpeg.exe', 'ffprobe.exe') },
  @{ Name = 'deno'; Version = '2.9.8'
     Url = 'https://github.com/denoland/deno/releases/download/v2.9.8/deno-x86_64-pc-windows-msvc.zip'
     Sha256 = 'cba84b26e0df5ae7f74fc66b86a95b866872a86292ebd84fa1e959927edd93bf'
     Keep = @('deno.exe') }
)
if (-not $All) { $pins = @($pins[0]) }

New-Item -ItemType Directory -Force $Into | Out-Null
$staging = Join-Path ([System.IO.Path]::GetTempPath()) "vidhoist-engine-$PID"
New-Item -ItemType Directory -Force $staging | Out-Null

try {
  foreach ($pin in $pins) {
    $zip = Join-Path $staging "$($pin.Name).zip"
    Write-Host "$($pin.Name) $($pin.Version): fetching"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $pin.Url -OutFile $zip -UseBasicParsing
    $hash = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($hash -ne $pin.Sha256) {
      throw "$($pin.Name): SHA-256 $hash, expected $($pin.Sha256). Nothing installed."
    }
    $unpacked = Join-Path $staging $pin.Name
    & "$env:SystemRoot\System32\tar.exe" -xf $zip -C (New-Item -ItemType Directory -Force $unpacked)
    if ($LASTEXITCODE -ne 0) { throw "$($pin.Name): tar could not unpack it" }

    $target = Join-Path $Into $pin.Name
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    if ($pin.Keep -contains '*') {
      # The folder build: the executable and its _internal folder, as one.
      $exe = Get-ChildItem $unpacked -Recurse -Filter 'yt-dlp.exe' | Select-Object -First 1
      Move-Item $exe.Directory.FullName $target
    } else {
      New-Item -ItemType Directory -Force $target | Out-Null
      foreach ($name in $pin.Keep) {
        $file = Get-ChildItem $unpacked -Recurse -Filter $name | Select-Object -First 1
        if (-not $file) { throw "$($pin.Name): $name is not in the archive" }
        Move-Item $file.FullName (Join-Path $target $name)
      }
    }
    Write-Host "$($pin.Name) $($pin.Version): in $target"
  }
} finally {
  Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
}
