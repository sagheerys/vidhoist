import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vh_core/vh_core.dart';

/// Starts a process; [Process.start] in the app, a fake in tests.
typedef ProcessStarter = Future<Process> Function(
  String executable,
  List<String> arguments, {
  Map<String, String>? environment,
});

/// What one command needs at the moment it starts: the engine can be
/// fetched, updated or reconfigured between two downloads.
class EngineRun {
  const EngineRun({
    required this.ytDlp,
    required this.setup,
    this.ffmpeg,
    this.deno,
  });

  final String ytDlp;
  final EngineSetup setup;

  /// The executables themselves, for their versions.
  final String? ffmpeg;
  final String? deno;
}

/// Ties a process and every child it starts together, so they stop as one.
///
/// yt-dlp starts Deno and ffmpeg as children, and [Process.kill] ends only
/// the first process: in the measurement the download went on and wrote
/// 9.6 MB more (`docs/ENGINE.md`, finding 5).
abstract interface class ProcessTree {
  /// Takes [process] in as soon as it has started.
  void adopt(Process process);

  /// Ends [process] and everything it started.
  Future<void> kill(Process process);

  /// Lets go of [process] once it has ended.
  void release(Process process);
}

/// yt-dlp run as a process on Windows, behind [DownloadBackend].
///
/// Every command reads the engine's place and options afresh through
/// [engine]; null there means yt-dlp is not on this computer, and each
/// call fails as [YtDlpErrorKind.engineMissing] rather than throwing
/// something the screens cannot word.
class ProcessYtDlpBackend implements DownloadBackend {
  ProcessYtDlpBackend({
    required this.engine,
    required this.probeFolder,
    ProcessStarter? start,
    required this.tree,
    this.updater,
    this.onLog,
    this.keepProbes = const Duration(hours: 6),
    DateTime Function()? clock,
  }) : _start = start ?? _processStart,
       _clock = clock ?? DateTime.now;

  final Future<EngineRun?> Function() engine;

  /// Where probes keep their JSON: the app's cache, never the download
  /// folder or a backup, because its media links are signed for this
  /// computer's address (`docs/ENGINE.md`, finding 19).
  final Directory probeFolder;
  final ProcessTree tree;

  /// Brings yt-dlp up to date; null where nothing can update it.
  final Future<UpdateOutcome> Function(EngineChannel channel)? updater;
  final void Function(String message)? onLog;

  /// A probe's media links expire after some hours; an older JSON is no
  /// use to a download and is swept.
  final Duration keepProbes;

  final ProcessStarter _start;
  final DateTime Function() _clock;
  final _running = <String, Process>{};
  final _cancelled = <String>{};
  var _probeCount = 0;

  /// yt-dlp writes in the console's code page unless told otherwise, and
  /// an Arabic title would then arrive as question marks.
  static const environment = {'PYTHONUTF8': '1', 'PYTHONIOENCODING': 'utf-8'};

  static Future<Process> _processStart(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
  }) => Process.start(executable, arguments, environment: environment);

  static const _missing = YtDlpError(
    YtDlpErrorKind.engineMissing,
    'yt-dlp is not on this computer',
  );

  @override
  Future<ProbeResult> probe(String url) async {
    final run = await engine();
    if (run == null) throw _missing;
    await _sweepProbes();
    final (:code, :stdout, :stderr) = await _collect(
      run.ytDlp,
      CommandBuilder.probe(url, run.setup),
    );
    if (code != 0) throw ErrorClassifier.classify(stderr);
    final info = InfoJson.parse(stdout);
    // Named by time and count, never by the link: the cache folder may be
    // listed in a log or a bug report.
    final file = File(
      '${probeFolder.path}${Platform.pathSeparator}'
      'probe-${_clock().microsecondsSinceEpoch}-${_probeCount++}.info.json',
    );
    try {
      await probeFolder.create(recursive: true);
      await file.writeAsString(stdout, flush: true);
      return ProbeResult(info, infoJsonPath: file.path);
    } on FileSystemException catch (e) {
      // The download then reads the link again: slower, not broken.
      onLog?.call('probe JSON not kept: ${e.osError?.message ?? e.message}');
      return ProbeResult(info);
    }
  }

  @override
  Future<InfoJson> list(String url, {int? limit}) async {
    final run = await engine();
    if (run == null) throw _missing;
    final (:code, :stdout, :stderr) = await _collect(
      run.ytDlp,
      CommandBuilder.playlist(url, run.setup, limit: limit),
    );
    if (code != 0) throw ErrorClassifier.classify(stderr);
    return InfoJson.parse(stdout);
  }

  @override
  Stream<BackendEvent> download(DownloadRequest request) async* {
    final run = await engine();
    if (run == null) {
      yield const BackendFailed(_missing);
      return;
    }
    final Process process;
    try {
      process = await _start(
        run.ytDlp,
        CommandBuilder.download(request.toSpec(), run.setup),
        environment: environment,
      );
    } on ProcessException catch (e) {
      onLog?.call('yt-dlp did not start: ${e.message}');
      yield const BackendFailed(_missing);
      return;
    }
    tree.adopt(process);
    _running[request.taskId] = process;
    final errors = StringBuffer();
    final readingErrors = process.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .forEach(errors.write);
    final exit = process.exitCode.then((code) async {
      await readingErrors;
      return (exitCode: code, stderr: errors.toString());
    });
    try {
      await for (final event in readDownloadRun(_lines(process), exit)) {
        if (_cancelled.contains(request.taskId)) break;
        yield event;
      }
    } finally {
      _running.remove(request.taskId);
      _cancelled.remove(request.taskId);
      tree.release(process);
    }
  }

  @override
  Future<void> cancel(String taskId) async {
    final process = _running[taskId];
    if (process == null) return;
    _cancelled.add(taskId);
    await tree.kill(process);
  }

  @override
  Future<BackendVersion> version() async {
    final run = await engine();
    if (run == null) return const BackendVersion();
    final ytDlp = await _firstLine(run.ytDlp, CommandBuilder.version());
    final ffmpeg = switch (run.ffmpeg) {
      final path? => await _firstLine(path, const ['-version']),
      null => null,
    };
    final deno = switch (run.deno) {
      final path? => await _firstLine(path, const ['--version']),
      null => null,
    };
    return BackendVersion(
      ytDlp: EngineVersion.tryParse(ytDlp),
      // "ffmpeg version 7.1-essentials… Copyright": the third word.
      ffmpeg: ffmpeg?.split(' ').elementAtOrNull(2),
      // "deno 2.9.8 (stable, …)": the name and the number.
      jsRuntime: deno?.split(' ').take(2).join(' '),
    );
  }

  @override
  Future<UpdateOutcome> updateEngine({
    EngineChannel channel = EngineChannel.stable,
  }) async =>
      await updater?.call(channel) ??
      const UpdateOutcome(updated: false, error: 'nothing can update yt-dlp');

  Stream<String> _lines(Process process) => process.stdout
      .transform(const Utf8Decoder(allowMalformed: true))
      .transform(const LineSplitter());

  Future<String?> _firstLine(String executable, List<String> args) async {
    try {
      final (:code, :stdout, stderr: _) = await _collect(executable, args);
      if (code != 0) return null;
      final line = const LineSplitter().convert(stdout).firstOrNull?.trim();
      return line == null || line.isEmpty ? null : line;
    } on ProcessException {
      return null;
    }
  }

  /// Runs a short command to its end: a probe, a version.
  Future<({int code, String stdout, String stderr})> _collect(
    String executable,
    List<String> args,
  ) async {
    final Process process;
    try {
      process = await _start(executable, args, environment: environment);
    } on ProcessException catch (e) {
      onLog?.call('$executable did not start: ${e.message}');
      throw _missing;
    }
    tree.adopt(process);
    try {
      const decoder = Utf8Decoder(allowMalformed: true);
      final out = process.stdout.transform(decoder).join();
      final err = process.stderr.transform(decoder).join();
      final code = await process.exitCode;
      return (code: code, stdout: await out, stderr: await err);
    } finally {
      tree.release(process);
    }
  }

  Future<void> _sweepProbes() async {
    if (!await probeFolder.exists()) return;
    final oldest = _clock().subtract(keepProbes);
    await for (final entry in probeFolder.list()) {
      if (entry is! File || !entry.path.endsWith('.info.json')) continue;
      try {
        if ((await entry.lastModified()).isBefore(oldest)) await entry.delete();
      } on FileSystemException {
        // In use or already gone: the next sweep tries again.
      }
    }
  }
}
