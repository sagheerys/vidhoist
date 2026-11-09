import 'package:vh_ytdlp/vh_ytdlp.dart';

import '../backend/download_backend.dart';
import '../storage/key_value_store.dart';

/// **yt-dlp updated when a download fails the way an outdated build
/// fails**, so the person never has to know a site changed.
///
/// A site moves on every few weeks; yt-dlp follows within days, and the
/// old build fails with a page it cannot read, a challenge it cannot
/// solve, or a 403 ([YtDlpError.maybeStaleEngine]). The download engine
/// asks here before giving up on such a failure: the engine updates, and
/// the download is tried once more. Attempts are kept apart by [minGap],
/// whatever they found, so a site that is simply down does not have the
/// app fetching yt-dlp at every failure; and one attempt serves every
/// download failing at the same time.
class EngineRefresh {
  EngineRefresh({
    required this.backend,
    required this.store,
    PrefsMutex? mutex,
    this.minGap = const Duration(hours: 6),
    DateTime Function()? now,
    this.onLog,
  }) : _mutex = mutex ?? PrefsMutex(),
       _now = now ?? DateTime.now;

  /// Never renamed: when yt-dlp was last brought up to date (or found
  /// current), by any path. The phone's weekly update reads it too.
  static const updatedAtKey = 'engine_updated_at';

  /// Never renamed: the last attempt made from a failure, successful or
  /// not, so a run of failures makes one attempt.
  static const attemptKey = 'engine_refresh_at';

  /// This device's own dates: a backup carries neither.
  static const deviceOnlyKeys = {updatedAtKey, attemptKey};

  final DownloadBackend backend;
  final KeyValueStore store;
  final Duration minGap;
  final void Function(String message)? onLog;
  final PrefsMutex _mutex;
  final DateTime Function() _now;
  Future<bool>? _inflight;

  /// Whether yt-dlp was updated because of [error]: true means a retry
  /// stands a chance. False for a failure that is not about the engine,
  /// an attempt made too recently, an engine already current, or an
  /// update that failed.
  Future<bool> afterFailure(YtDlpError error) {
    if (!error.maybeStaleEngine) return Future.value(false);
    return _inflight ??= _refresh(error).whenComplete(() => _inflight = null);
  }

  /// **What a repair leaves behind** (`DownloadBackend.repairEngine`). The
  /// attempt from a failure is forgotten, so the next failure that looks
  /// like an old build may update again at once rather than hours later.
  /// A repair that finished counts as an update; one that could not fetch
  /// yt-dlp clears the date instead, so the next start (the phone's
  /// preparer, Windows' weekly check) tries the update again.
  static Future<void> recordRepair(
    KeyValueStore store,
    PrefsMutex mutex,
    UpdateOutcome outcome, {
    DateTime? at,
  }) => mutex.run(() async {
    await store.remove(attemptKey);
    if (outcome.error == null) {
      await store.setInt(
        updatedAtKey,
        (at ?? DateTime.now()).millisecondsSinceEpoch,
      );
    } else {
      await store.remove(updatedAtKey);
    }
  });

  Future<bool> _refresh(YtDlpError error) async {
    final now = _now();
    final last = await store.getInt(attemptKey);
    if (last != null &&
        now.difference(DateTime.fromMillisecondsSinceEpoch(last)) < minGap) {
      onLog?.call('engine refresh skipped, tried lately: ${error.kind.name}');
      return false;
    }
    await _mutex.run(
      () => store.setInt(attemptKey, now.millisecondsSinceEpoch),
    );
    onLog?.call('engine refresh after ${error.kind.name}');
    UpdateOutcome outcome;
    try {
      outcome = await backend.updateEngine();
    } on Object catch (e) {
      outcome = UpdateOutcome(updated: false, error: '$e');
    }
    if (outcome.error == null) {
      await _mutex.run(
        () => store.setInt(updatedAtKey, now.millisecondsSinceEpoch),
      );
    }
    onLog?.call(
      'engine refresh: ${outcome.updated ? 'updated to ${outcome.version}' : outcome.error ?? 'already current'}',
    );
    return outcome.updated;
  }
}
