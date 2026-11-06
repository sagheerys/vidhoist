import 'dart:async';
import 'dart:io' show File, FileSystemException;

import 'package:mt_ytdlp/mt_ytdlp.dart' show YtDlpError;

import '../api/api_exceptions.dart';
import '../backend/download_backend.dart';
import '../models/download_task.dart';
import '../models/quality.dart';
import '../storage/local_history_store.dart';
import '../urls/url_kit.dart';
import 'download_queue.dart';
import 'local_pending.dart';

/// The folder a task's file goes to; the app decides.
typedef TaskFolder = String Function(DownloadTask task);

/// Downloads with yt-dlp on this device, through a [DownloadBackend].
///
/// What the screens use is the same as on the server engine (`submit`,
/// `cancel`, `forget`, [updates], [tasks]), so the cards and panels keep
/// working while the server engine is retired. Each task goes
/// `queued → preparing → downloading → postprocessing → completed`, or
/// ends `failed` or `cancelled`; [pause] keeps the partial file for
/// [resume].
///
/// Preparing probes the link once and the download starts from that probe
/// (`docs/ENGINE.md`, finding 19): on a phone this halves YouTube's wait.
class LocalDownloadEngine {
  LocalDownloadEngine({
    required this.backend,
    required this.folderFor,
    this.history,
    this.pending,
    this.maxConcurrent = 1,
    this.startGate,
    this.gateRecheck = const Duration(seconds: 15),
    this.compatibleVideo,
    this.subtitleLanguages,
    this.onCompleted,
    this.onLog,
    Future<int?> Function(String path)? sizeOf,
  }) : _sizeOf = sizeOf ?? _fileSize;

  final DownloadBackend backend;
  final TaskFolder folderFor;

  /// Where finished downloads are recorded; null records nothing.
  final LocalHistoryStore? history;

  /// Where unfinished downloads are written down for the next launch.
  final LocalPendingStore? pending;

  /// How many downloads run at once.
  final int maxConcurrent;

  /// "Wi-Fi only": asked before a download starts, and again every
  /// [gateRecheck] while it says no. The app answers it; the core does not
  /// know the network.
  final bool Function()? startGate;
  final Duration gateRecheck;

  /// Read when each download starts, so changing the setting needs no new
  /// engine.
  final bool Function()? compatibleVideo;
  final List<String> Function()? subtitleLanguages;

  final void Function(DownloadTask task)? onCompleted;
  final void Function(String message)? onLog;
  final Future<int?> Function(String path) _sizeOf;

  final _queue = DownloadQueue();
  final _tasks = <String, DownloadTask>{};
  final _running = <String>{};
  final _probes = <String, ProbeResult>{};

  /// Why a running task is being stopped: [TaskPhase.cancelled] or
  /// [TaskPhase.paused].
  final _stops = <String, TaskPhase>{};
  final _wakers = <String, Completer<void>>{};
  final _lastPercent = <String, int>{};
  final _updates = StreamController<DownloadTask>.broadcast();
  bool _disposed = false;

  Stream<DownloadTask> get updates => _updates.stream;
  List<DownloadTask> get tasks => List.unmodifiable(_tasks.values);
  DownloadTask? taskById(String id) => _tasks[id];
  bool get hasActiveWork => _tasks.values.any((t) => !t.isFinished);

  /// Enqueues the first link found in [text].
  DownloadTask submit(
    String text,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
  }) {
    final url = UrlKit.extractUrl(text);
    final task = DownloadTask(
      inputUrl: url,
      quality: quality.applyRule(url),
      isBatchMember: isBatchMember,
      folder: folder,
    );
    _enqueue(task);
    onLog?.call('submit ${task.quality.wire} $url');
    return task;
  }

  /// Queues again what the last run left unfinished; the number restored.
  Future<int> restorePending() async {
    final saved = await pending?.load() ?? const <DownloadTask>[];
    for (final task in saved) {
      if (_tasks.containsKey(task.id)) continue;
      if (task.phase == TaskPhase.paused) {
        _set(task);
      } else {
        _enqueue(task, record: false);
      }
    }
    return saved.length;
  }

  void cancel(String taskId) => _stop(taskId, TaskPhase.cancelled);

  /// Stops [taskId] and keeps its partial file; [resume] continues it.
  void pause(String taskId) => _stop(taskId, TaskPhase.paused);

  void resume(String taskId) {
    final task = _tasks[taskId];
    if (task == null || task.phase != TaskPhase.paused) return;
    _enqueue(task.copyWith(phase: TaskPhase.queued));
  }

  /// Removes a finished task from [tasks], for a failed card that was
  /// submitted again.
  void forget(String taskId) {
    final task = _tasks[taskId];
    if (task == null || !task.isFinished) return;
    _tasks.remove(taskId);
    _probes.remove(taskId);
    if (!_updates.isClosed) _updates.add(task);
  }

  /// Stops every running download and keeps their records, so the next
  /// launch continues them.
  Future<void> dispose() async {
    _disposed = true;
    for (final id in _running.toList()) {
      _wake(id);
      await backend.cancel(id);
    }
    await _updates.close();
  }

  void _enqueue(DownloadTask task, {bool record = true}) {
    _set(task);
    _queue.enqueue(task.id, isBatchMember: task.isBatchMember);
    if (record) unawaited(_record(task));
    _pump();
  }

  void _stop(String taskId, TaskPhase why) {
    final task = _tasks[taskId];
    if (task == null || task.isFinished) return;
    final waiting = _queue.remove(taskId) || task.phase == TaskPhase.paused;
    if (why == TaskPhase.paused && task.phase == TaskPhase.paused) return;
    final stopped = _set(task.copyWith(phase: why, speed: () => null));
    unawaited(
      why == TaskPhase.cancelled ? _unrecord(taskId) : _record(stopped),
    );
    if (waiting) return;
    _stops[taskId] = why;
    _wake(taskId);
    unawaited(backend.cancel(taskId));
  }

  void _pump() {
    while (!_disposed && _running.length < maxConcurrent) {
      final id = _queue.takeNext();
      if (id == null) return;
      _running.add(id);
      unawaited(
        _run(id).whenComplete(() {
          _running.remove(id);
          _stops.remove(id);
          _pump();
        }),
      );
    }
  }

  Future<void> _run(String id) async {
    try {
      await _prepare(id);
      if (_stopped(id)) return;
      await _download(id);
    } on Object catch (e) {
      if (_stopped(id)) return;
      onLog?.call('failed $id: $e');
      await _fail(id, _classify(e));
    }
  }

  Future<void> _prepare(String id) async {
    var task = _set(_tasks[id]!.copyWith(phase: TaskPhase.preparing));
    final probe = _probes[id] ??= await backend.probe(task.effectiveUrl);
    if (_stopped(id)) return;
    task = _set(
      task.copyWith(
        title: probe.info.title,
        thumbnail: probe.info.thumbnail,
        canonicalUrl: probe.info.webpageUrl,
      ),
    );
    unawaited(_record(task));
    while (startGate != null && !startGate!() && !_stopped(id)) {
      _set(_tasks[id]!.copyWith(phase: TaskPhase.waitingForNetwork));
      final waker = _wakers[id] = Completer<void>();
      await Future.any([Future<void>.delayed(gateRecheck), waker.future]);
      _wakers.remove(id);
    }
  }

  Future<void> _download(String id) async {
    final task = _tasks[id]!;
    var request = DownloadRequest(
      taskId: id,
      url: task.effectiveUrl,
      folder: folderFor(task),
      quality: task.quality,
      compatible: compatibleVideo?.call() ?? false,
      infoJsonPath: _probes[id]?.infoJsonPath,
      subtitleLanguages: subtitleLanguages?.call() ?? const [],
    );
    _set(task.copyWith(phase: TaskPhase.downloading, progress: 0));
    while (true) {
      BackendEvent? end;
      await for (final event in backend.download(request)) {
        if (_stopped(id)) return;
        switch (event) {
          case BackendProgress(:final progress):
            _progress(id, progress.fraction, progress.speed, progress.eta);
          case BackendPostprocessing():
            _set(_tasks[id]!.copyWith(phase: TaskPhase.postprocessing));
          case BackendFinished() || BackendFailed():
            end = event;
        }
      }
      if (_stopped(id)) return;
      switch (end) {
        case BackendFinished(:final path):
          return _complete(id, path);
        // A ceiling a site cannot meet is refused, not ignored: once more
        // at the best the site has.
        case BackendFailed(:final error)
            when error.retryAtBest && request.quality != Quality.best:
          onLog?.call('retry $id at best: ${error.message}');
          request = request.copyWith(quality: Quality.best);
        case BackendFailed(:final error):
          return _fail(id, EngineFailureException.from(error));
        case _:
          return _fail(id, const LocalFailureException('no result'));
      }
    }
  }

  Future<void> _complete(String id, String path) async {
    final task = _tasks[id]!;
    final probe = _probes.remove(id);
    final size = await _sizeOf(path);
    await history?.record(
      task: task,
      path: path,
      info: probe?.info,
      sizeBytes: size,
    );
    // Everything written before the task says it is done: whoever reacts
    // to "completed" finds the library and the records already settled.
    await _unrecord(id);
    onLog?.call('completed $id $path');
    final done = task.copyWith(
      phase: TaskPhase.completed,
      progress: 1,
      localPath: path,
      speed: () => null,
      eta: () => null,
    );
    _tasks[id] = done;
    onCompleted?.call(done);
    _set(done);
  }

  Future<void> _fail(String id, MTApiException error) async {
    _probes.remove(id);
    await _unrecord(id);
    _set(
      _tasks[id]!.copyWith(
        phase: TaskPhase.failed,
        error: error,
        speed: () => null,
      ),
    );
  }

  /// Broadcasts progress at whole percentages only: yt-dlp prints many
  /// lines a second, and each one rebuilt every card.
  void _progress(String id, double fraction, double? speed, int? eta) {
    final task = _tasks[id]!;
    final percent = (fraction * 100).floor();
    if (_lastPercent[id] == percent && task.phase == TaskPhase.downloading) {
      return;
    }
    _lastPercent[id] = percent;
    _set(
      task.copyWith(
        phase: TaskPhase.downloading,
        progress: fraction,
        speed: () => speed,
        eta: () => eta,
      ),
    );
  }

  bool _stopped(String id) => _disposed || _stops.containsKey(id);

  void _wake(String id) => _wakers.remove(id)?.complete();

  DownloadTask _set(DownloadTask task) {
    _tasks[task.id] = task;
    if (!_updates.isClosed) _updates.add(task);
    return task;
  }

  Future<void> _record(DownloadTask task) async {
    try {
      await pending?.put(task);
    } on Object catch (e) {
      // A lost record costs a resume after a crash, never the download.
      onLog?.call('pending record failed: $e');
    }
  }

  Future<void> _unrecord(String id) async {
    try {
      await pending?.remove(id);
    } on Object catch (e) {
      onLog?.call('pending removal failed: $e');
    }
  }

  static MTApiException _classify(Object e) => switch (e) {
    MTApiException() => e,
    YtDlpError() => EngineFailureException.from(e),
    _ => LocalFailureException('$e'),
  };

  static Future<int?> _fileSize(String path) async {
    try {
      return await File(path).length();
    } on FileSystemException {
      return null;
    }
  }
}
