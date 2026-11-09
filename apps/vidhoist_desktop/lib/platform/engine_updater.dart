import 'dart:convert';
import 'dart:io';

import 'package:vh_core/vh_core.dart';

import 'engine_locator.dart';
import 'engine_pins.dart';

/// A short command's exit code and everything it printed.
typedef RunResult = ({int code, String output});

/// Brings yt-dlp up to date. YouTube breaks old builds within months, so
/// this stays one click away in the engine settings.
///
/// The folder build the app ships cannot update itself (yt-dlp's `-U`
/// refuses unpackaged builds), so the app fetches the newer release
/// itself, checked against that release's own SHA2-256SUMS. A yt-dlp
/// found on PATH is someone's one-file build, which `-U` does update.
class EngineUpdater {
  EngineUpdater({
    required this.locate,
    required this.currentVersion,
    required this.install,
    Future<String> Function(Uri url)? getText,
    Future<RunResult> Function(String exe, List<String> args)? run,
  }) : _getText = getText ?? _httpText,
       _run = run ?? _runProcess;

  final EnginePaths Function() locate;
  final Future<EngineVersion?> Function() currentVersion;

  /// Fetches and puts in place a release file (the engine fetcher).
  final Future<void> Function(PinnedAsset asset) install;
  final Future<String> Function(Uri url) _getText;
  final Future<RunResult> Function(String exe, List<String> args) _run;

  static const _asset = 'yt-dlp_win.zip';

  Future<UpdateOutcome> update(EngineChannel channel) async {
    final paths = locate();
    final exe = paths.ytDlp;
    if (exe == null) {
      return const UpdateOutcome(updated: false, error: 'no yt-dlp to update');
    }
    try {
      return paths.managed
          ? await _replace(channel)
          : await _selfUpdate(exe, channel);
    } on Object catch (e) {
      return UpdateOutcome(
        updated: false,
        version: await currentVersion(),
        error: '$e',
      );
    }
  }

  /// **"Repair the engine"** (`DownloadBackend.repairEngine`): yt-dlp's
  /// own `--rm-cache-dir` first, which drops what it saved of YouTube's
  /// player code (the classic cure when every YouTube link fails at once,
  /// and it needs no network); then a fresh copy of the current release,
  /// checked against its SHA2-256SUMS, even when the version there claims
  /// to be current, since a damaged copy reports the right number. The
  /// copy in use is replaced only once the new one is whole, so a repair
  /// that cannot fetch leaves a working yt-dlp. A yt-dlp on PATH is
  /// someone's own, and gets the cache and its own `-U`.
  Future<UpdateOutcome> repair() async {
    final paths = locate();
    final exe = paths.ytDlp;
    if (exe == null) {
      return const UpdateOutcome(updated: false, error: 'no yt-dlp to repair');
    }
    try {
      await _run(exe, const ['--rm-cache-dir']);
      return paths.managed
          ? await _replace(EngineChannel.stable, force: true)
          : await _selfUpdate(exe, EngineChannel.stable);
    } on Object catch (e) {
      return UpdateOutcome(
        updated: false,
        version: await currentVersion(),
        error: '$e',
      );
    }
  }

  Future<UpdateOutcome> _replace(
    EngineChannel channel, {
    bool force = false,
  }) async {
    final repo = switch (channel) {
      EngineChannel.stable => 'yt-dlp/yt-dlp',
      EngineChannel.nightly => 'yt-dlp/yt-dlp-nightly-builds',
    };
    final release = jsonDecode(
      await _getText(
        Uri.https('api.github.com', '/repos/$repo/releases/latest'),
      ),
    ) as Map<String, Object?>;
    final tag = release['tag_name'] as String?;
    final latest = EngineVersion.tryParse(tag);
    final current = await currentVersion();
    if (tag == null || latest == null) {
      return UpdateOutcome(
        updated: false,
        version: current,
        error: 'the release names no version',
      );
    }
    if (!force && current != null && latest.compareTo(current) <= 0) {
      return UpdateOutcome(updated: false, version: current);
    }
    final base = '/$repo/releases/download/$tag';
    final sums = await _getText(Uri.https('github.com', '$base/SHA2-256SUMS'));
    final sha = _sumFor(sums, _asset);
    if (sha == null) {
      return UpdateOutcome(
        updated: false,
        version: current,
        error: 'no checksum for $_asset in $tag',
      );
    }
    await install(
      PinnedAsset(
        part: EnginePart.ytDlp,
        version: tag,
        url: Uri.https('github.com', '$base/$_asset'),
        sha256: sha,
      ),
    );
    return UpdateOutcome(updated: true, version: latest);
  }

  Future<UpdateOutcome> _selfUpdate(String exe, EngineChannel channel) async {
    final result = await _run(exe, switch (channel) {
      EngineChannel.stable => const ['-U'],
      EngineChannel.nightly => const ['--update-to', 'nightly'],
    });
    final updated = RegExp(
      r'Updated yt-dlp to \S*?@?(\d{4}\.\d{2}\.\d{2}(?:\.\d+)?)',
    ).firstMatch(result.output);
    if (updated != null) {
      return UpdateOutcome(
        updated: true,
        version: EngineVersion.tryParse(updated.group(1)),
      );
    }
    return UpdateOutcome(
      updated: false,
      version: await currentVersion(),
      error: result.code == 0 ? null : result.output.trim(),
    );
  }

  /// The hash beside [name] in a `sha256sum` listing.
  static String? _sumFor(String sums, String name) {
    for (final line in const LineSplitter().convert(sums)) {
      final parts = line.trim().split(RegExp(r'\s+\*?'));
      if (parts.length == 2 &&
          parts[1] == name &&
          RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(parts[0])) {
        return parts[0].toLowerCase();
      }
    }
    return null;
  }

  static Future<String> _httpText(Uri url) async {
    final client = HttpClient()..userAgent = 'VidHoist';
    try {
      final request = await client.getUrl(url);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}', uri: url);
      }
      return await response.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }

  static Future<RunResult> _runProcess(String exe, List<String> args) async {
    final result = await Process.run(
      exe,
      args,
      environment: const {'PYTHONUTF8': '1'},
    );
    return (code: result.exitCode, output: '${result.stdout}${result.stderr}');
  }
}
