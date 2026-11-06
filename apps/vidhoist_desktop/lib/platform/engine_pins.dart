import 'engine_locator.dart';

/// One release file, named exactly, with the SHA-256 it must have.
class PinnedAsset {
  const PinnedAsset({
    required this.part,
    required this.version,
    required this.url,
    required this.sha256,
  });

  final EnginePart part;
  final String version;
  final Uri url;

  /// Lower-case hex; a file that does not match is never unpacked.
  final String sha256;
}

/// The versions the app fetches, each hash read from its release
/// (GitHub's asset digest, and for yt-dlp the release's own SHA2-256SUMS).
/// `tool/fetch-engine.ps1` pins the same yt-dlp for the installer; the two
/// change together.
final enginePins = <EnginePart, PinnedAsset>{
  EnginePart.ytDlp: PinnedAsset(
    part: EnginePart.ytDlp,
    version: '2026.10.26',
    url: Uri.parse(
      'https://github.com/yt-dlp/yt-dlp/releases/download/2026.10.26/yt-dlp_win.zip',
    ),
    sha256: 'fd51b212cf8380c7a52ee08c0d6be7f3c59b2f2c832eaf7b45acfae6eab57419',
  ),
  // Gyan's essentials build: tagged releases that stay up, unlike the
  // daily builds yt-dlp links to, which are replaced within weeks.
  EnginePart.ffmpeg: PinnedAsset(
    part: EnginePart.ffmpeg,
    version: '9.0.2',
    url: Uri.parse(
      'https://github.com/GyanD/codexffmpeg/releases/download/9.0.2/ffmpeg-9.0.2-essentials_build.zip',
    ),
    sha256: '60f467265b1e312373dbcd92200c2618a74850f98d3d078e94296bb3fa2047ba',
  ),
  // The version measured with YouTube's challenge (`docs/ENGINE.md`).
  EnginePart.deno: PinnedAsset(
    part: EnginePart.deno,
    version: '2.9.8',
    url: Uri.parse(
      'https://github.com/denoland/deno/releases/download/v2.9.8/deno-x86_64-pc-windows-msvc.zip',
    ),
    sha256: 'cba84b26e0df5ae7f74fc66b86a95b866872a86292ebd84fa1e959927edd93bf',
  ),
};
