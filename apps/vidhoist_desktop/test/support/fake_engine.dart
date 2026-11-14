import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';

/// A download engine that records what it is given and runs nothing; a
/// test moves a task along with [advance], [fail] or [finish].
class FakeEngine extends Fake implements LocalDownloadEngine {
  final List<DownloadTask> submitted = [];
  final _updates = StreamController<DownloadTask>.broadcast();
  final _tasks = <String, DownloadTask>{};

  @override
  DownloadTask submit(
    String text,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
    ClipRange? clip,
  }) {
    final task = DownloadTask(
      inputUrl: text,
      quality: quality,
      isBatchMember: isBatchMember,
      folder: folder,
      clip: clip,
    );
    submitted.add(task);
    _put(task);
    return task;
  }

  /// Shows [task] as it is now, as the engine would.
  void put(DownloadTask task) => _put(task);

  void _put(DownloadTask task) {
    _tasks[task.id] = task;
    _updates.add(task);
  }

  void fail(DownloadTask task, VhApiException error) =>
      _put(task.copyWith(phase: TaskPhase.failed, error: error));

  /// As if yt-dlp reported [progress] on it.
  void advance(DownloadTask task, double progress) =>
      _put(task.copyWith(phase: TaskPhase.downloading, progress: progress));

  void finish(DownloadTask task) =>
      _put(task.copyWith(phase: TaskPhase.completed));

  /// What was cancelled, paused, resumed and forgotten, by task id.
  final List<String> cancelled = [];
  final List<String> paused = [];
  final List<String> resumed = [];
  final List<String> forgotten = [];

  @override
  void cancel(String taskId) {
    cancelled.add(taskId);
    if (_tasks[taskId] case final task?) {
      _put(task.copyWith(phase: TaskPhase.cancelled));
    }
  }

  @override
  void pause(String taskId) {
    paused.add(taskId);
    if (_tasks[taskId] case final task?) {
      _put(task.copyWith(phase: TaskPhase.paused));
    }
  }

  @override
  void resume(String taskId) {
    resumed.add(taskId);
    if (_tasks[taskId] case final task?) {
      _put(task.copyWith(phase: TaskPhase.queued));
    }
  }

  @override
  void forget(String taskId) {
    forgotten.add(taskId);
    _tasks.remove(taskId);
    _updates.add(DownloadTask(inputUrl: '', quality: Quality.best));
  }

  @override
  Future<int> restorePending() async => 0;

  @override
  Stream<DownloadTask> get updates => _updates.stream;

  @override
  DownloadTask? taskById(String id) => _tasks[id];

  @override
  List<DownloadTask> get tasks => _tasks.values.toList();

  @override
  bool get hasActiveWork => _tasks.values.any((t) => !t.isFinished);

  @override
  Future<void> dispose() async {}
}
