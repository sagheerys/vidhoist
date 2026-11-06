import 'dart:async';

import 'package:mt_core/mt_core.dart';

import 'ytdlp_bridge.dart';

/// Where the engine stands, for the welcome screen and the settings.
enum EngineStage { idle, unpacking, updating, ready, failed }

class EngineStatus {
  const EngineStatus({
    this.stage = EngineStage.idle,
    this.version,
    this.updatedAt,
    this.updateFailed = false,
    this.error,
  });

  final EngineStage stage;

  /// yt-dlp's version; null until its first update (the library does not
  /// know the one it ships with).
  final EngineVersion? version;
  final DateTime? updatedAt;

  /// The last update could not be made, usually for want of a network.
  final bool updateFailed;

  /// Why unpacking failed, for the log.
  final String? error;

  bool get isBusy =>
      stage == EngineStage.unpacking || stage == EngineStage.updating;

  EngineStatus copyWith({
    EngineStage? stage,
    EngineVersion? version,
    DateTime? updatedAt,
    bool? updateFailed,
    String? error,
  }) => EngineStatus(
    stage: stage ?? this.stage,
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    updateFailed: updateFailed ?? this.updateFailed,
    error: error,
  );
}

/// Gets the engine ready before the first run: unpacks Python and ffmpeg
/// (about 4 s the first time on a phone), then updates yt-dlp, because the
/// one the library ships is a year old and fails on YouTube
/// (`docs/ENGINE.md` findings 11 and 12). Later launches update once a
/// week, since YouTube breaks old builds within months.
class EnginePreparer {
  EnginePreparer({
    required this.bridge,
    required this.store,
    PrefsMutex? mutex,
    DateTime Function()? now,
    this.updateEvery = const Duration(days: 7),
    this.onLog,
  }) : _mutex = mutex ?? PrefsMutex(),
       _now = now ?? DateTime.now;

  /// Never renamed: the date of the last update that worked.
  static const updatedAtKey = 'engine_updated_at';

  final YtDlpBridge bridge;
  final KeyValueStore store;
  final Duration updateEvery;
  final void Function(String message)? onLog;
  final PrefsMutex _mutex;
  final DateTime Function() _now;

  final _statuses = StreamController<EngineStatus>.broadcast();
  EngineStatus _status = const EngineStatus();
  Future<void>? _unpacked;
  Future<void>? _ready;

  EngineStatus get status => _status;
  Stream<EngineStatus> get statuses => _statuses.stream;

  /// Ready to run. Shared by every caller; a failed unpacking throws and
  /// is tried again at the next call. A failed first update does not
  /// throw: other sites still work with the shipped yt-dlp, and the next
  /// call tries the update again.
  Future<void> ensure() => _ready ??= _prepare().then(
    (_) {
      if (_status.updateFailed && _status.updatedAt == null) _ready = null;
    },
    onError: (Object e) {
      _ready = null;
      throw e;
    },
  );

  /// The update button: updates now; false when it could not.
  Future<bool> update() async {
    await _unpack();
    return _update();
  }

  Future<void> _prepare() async {
    await _unpack();
    final at = await _lastUpdate();
    _status = _status.copyWith(updatedAt: at);
    final due = at == null || _now().difference(at) >= updateEvery;
    if (due) await _update();
    _set(
      _status.copyWith(
        stage: EngineStage.ready,
        version: EngineVersion.tryParse(await bridge.version()),
      ),
    );
  }

  Future<void> _unpack() => _unpacked ??= () async {
    _set(_status.copyWith(stage: EngineStage.unpacking));
    final started = _now();
    try {
      await bridge.init();
    } on Object catch (e) {
      _unpacked = null;
      _set(_status.copyWith(stage: EngineStage.failed, error: '$e'));
      onLog?.call('engine init failed: $e');
      rethrow;
    }
    onLog?.call(
      'engine ready in ${_now().difference(started).inMilliseconds}ms',
    );
  }();

  Future<bool> _update() async {
    _set(_status.copyWith(stage: EngineStage.updating));
    try {
      final result = await bridge.update();
      final at = _now();
      await _mutex.run(
        () => store.setInt(updatedAtKey, at.millisecondsSinceEpoch),
      );
      _set(
        _status.copyWith(
          stage: EngineStage.ready,
          updatedAt: at,
          updateFailed: false,
          version: EngineVersion.tryParse(result.version),
        ),
      );
      onLog?.call('engine update: ${result.updated ? 'new' : 'current'}');
      return true;
    } on Object catch (e) {
      _set(_status.copyWith(stage: EngineStage.ready, updateFailed: true));
      onLog?.call('engine update failed: $e');
      return false;
    }
  }

  Future<DateTime?> _lastUpdate() async {
    final ms = await store.getInt(updatedAtKey);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  void _set(EngineStatus status) {
    _status = status;
    if (!_statuses.isClosed) _statuses.add(status);
  }

  Future<void> dispose() => _statuses.close();
}
