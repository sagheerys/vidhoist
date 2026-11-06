import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show PlatformException;
import 'package:mt_core/mt_core.dart';

import 'ytdlp_bridge.dart';

/// yt-dlp on the phone, through youtubedl-android ([YtDlpBridge]).
///
/// The command lines come from `mt_ytdlp` whole and in order (the library's
/// own option list reorders them, `docs/ENGINE.md` finding 21), and what a
/// run prints goes through [readDownloadRun], as on Windows.
class ChannelYtDlpBackend implements DownloadBackend {
  ChannelYtDlpBackend({
    required this.bridge,
    required this.cacheDir,
    required this.forceIpv4,
    required this.ready,
    this.probeLifetime = const Duration(hours: 6),
  });

  final YtDlpBridge bridge;

  /// The app's private cache folder, where probes keep their JSON: it holds
  /// links signed for this device's address, so it never goes anywhere
  /// public.
  final Future<String> Function() cacheDir;

  /// The engine setting, read at each run.
  final bool Function() forceIpv4;

  /// Unpacks the engine, and updates it the first time, before any run
  /// (`docs/ENGINE.md` findings 11 and 12).
  final Future<void> Function() ready;

  /// How long a probe's media links are trusted: they expire after some
  /// hours, and a download from an older probe reads the link again.
  final Duration probeLifetime;

  final _downloads = <String>{};
  final _probes = <String>{};
  final _stopAsked = <String>{};
  var _count = 0;

  EngineSetup get _setup =>
      EngineSetup(platform: HostPlatform.android, forceIpv4: forceIpv4());

  @override
  Future<ProbeResult> probe(String url) async {
    final id = 'probe-${DateTime.now().microsecondsSinceEpoch}-${_count++}';
    _probes.add(id);
    final String kept;
    final BridgeRun run;
    try {
      kept = '${(await _probeFolder()).path}/$id.json';
      await ready();
      if (_stopAsked.remove(id)) throw const CancelledException();
      run = await bridge.execute(
        id,
        CommandBuilder.probe(url, _setup),
        stdoutFile: kept,
      );
    } on PlatformException catch (e) {
      throw _broken(e);
    } finally {
      _probes.remove(id);
      _stopAsked.remove(id);
    }
    if (run.cancelled) throw const CancelledException();
    if (run.exitCode != 0) {
      await _delete(kept);
      throw ErrorClassifier.classify(run.stderr);
    }
    try {
      return ProbeResult(
        InfoJson.parse(await File(kept).readAsString()),
        infoJsonPath: kept,
      );
    } on Object catch (e) {
      await _delete(kept);
      throw YtDlpError(YtDlpErrorKind.failed, 'unreadable probe: $e');
    }
  }

  @override
  Stream<BackendEvent> download(DownloadRequest request) async* {
    final id = request.taskId;
    _stopAsked.remove(id);
    var run = request;
    final info = request.infoJsonPath;
    if (info != null && !await _fresh(info)) {
      run = request.copyWith(infoJsonPath: () => null);
    }
    final lines = StreamController<String>();
    final heard = bridge.lines
        .where((l) => l.id == id)
        .listen((l) => lines.add(l.line));
    var stopped = false;
    YtDlpError? broken;

    Future<RunExit> execute() async {
      try {
        await ready();
        if (_stopAsked.remove(id)) {
          stopped = true;
          return (exitCode: 1, stderr: '');
        }
        _downloads.add(id);
        final end = await bridge.execute(
          id,
          CommandBuilder.download(run.toSpec(), _setup),
        );
        stopped = end.cancelled;
        return (exitCode: end.exitCode, stderr: end.stderr);
      } on PlatformException catch (e) {
        broken = _broken(e);
        return (exitCode: 1, stderr: '');
      } finally {
        _downloads.remove(id);
        await heard.cancel();
        await lines.close();
      }
    }

    await for (final event in readDownloadRun(lines.stream, execute())) {
      if (event is BackendFinished || event is BackendFailed) {
        if (stopped) return;
        if (broken case final error?) {
          yield BackendFailed(error);
          return;
        }
        if (event is BackendFinished && run.infoJsonPath != null) {
          await _delete(run.infoJsonPath!);
        }
      }
      yield event;
    }
  }

  /// The phone runs one task at a time, so a probe running when its task is
  /// stopped belongs to that task: the probe has no task id of its own.
  @override
  Future<void> cancel(String taskId) async {
    if (_downloads.contains(taskId)) {
      await bridge.cancel(taskId);
      return;
    }
    // Asked before the run starts, the stop is kept for it to find.
    _stopAsked
      ..add(taskId)
      ..addAll(_probes);
    for (final probe in _probes.toList()) {
      await bridge.cancel(probe);
    }
  }

  @override
  Future<BackendVersion> version() async {
    try {
      return BackendVersion(
        ytDlp: EngineVersion.tryParse(await bridge.version()),
        // The library passes QuickJS on every request (finding 13).
        jsRuntime: 'quickjs',
      );
    } on PlatformException {
      return const BackendVersion();
    }
  }

  @override
  Future<UpdateOutcome> updateEngine({
    EngineChannel channel = EngineChannel.stable,
  }) async {
    try {
      final result = await bridge.update(
        nightly: channel == EngineChannel.nightly,
      );
      return UpdateOutcome(
        updated: result.updated,
        version: EngineVersion.tryParse(result.version),
      );
    } on PlatformException catch (e) {
      return UpdateOutcome(updated: false, error: e.message ?? e.code);
    }
  }

  static YtDlpError _broken(PlatformException e) =>
      YtDlpError(YtDlpErrorKind.engineMissing, e.message ?? e.code);

  Future<Directory> _probeFolder() async {
    final dir = Directory('${await cacheDir()}/probes');
    await dir.create(recursive: true);
    // A probe nobody downloaded from (the task failed, or the app was
    // killed) goes once its links have expired.
    await for (final entry in dir.list()) {
      if (entry is File && !await _fresh(entry.path)) await _delete(entry.path);
    }
    return dir;
  }

  Future<bool> _fresh(String path) async {
    try {
      final at = await File(path).lastModified();
      return DateTime.now().difference(at) < probeLifetime;
    } on FileSystemException {
      return false;
    }
  }

  static Future<void> _delete(String path) async {
    try {
      await File(path).delete();
    } on FileSystemException {
      // Already gone.
    }
  }
}
