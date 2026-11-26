part of 'local_download_engine.dart';

/// How a task ends and how each step is told: the record kept for a
/// resume after a crash, the progress at whole percentages, and the update
/// every screen listens to.
extension _Finish on LocalDownloadEngine {
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

  Future<void> _fail(String id, VhApiException error) async {
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

  /// Deletes a cancelled task's work files once its download has ended:
  /// deleted while yt-dlp still ran, a file would be written again, and on
  /// Windows one still open cannot be deleted at all. Nothing is deleted
  /// while another unfinished task fetches the same video, since the files
  /// would then be that task's.
  Future<void> _dropPartials(
    DownloadTask task, {
    Future<void>? stopping,
  }) async {
    final media = task.mediaId;
    if (media == null) return;
    final run = _runs[task.id];
    bool sharedWith(DownloadTask t) =>
        t.id != task.id &&
        !t.isFinished &&
        (t.mediaId == media || t.effectiveUrl == task.effectiveUrl);
    try {
      final folder = folderFor(task);
      try {
        await stopping;
        await run?.timeout(const Duration(seconds: 10));
      } on Object catch (e) {
        // A stop that did not answer: the retries below wait for the files.
        onLog?.call('stop of ${task.id} not confirmed: $e');
      }
      final removed = await removeTaskPartials(
        folder,
        media,
        clip: task.clip,
        stillWanted: () => !_tasks.values.any(sharedWith),
      );
      if (removed > 0) onLog?.call('removed $removed partials of ${task.id}');
    } on Object catch (e) {
      // Space left taken is never worth a crash; the startup sweep is the
      // second chance.
      onLog?.call('partials of ${task.id} kept: $e');
    }
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
}
