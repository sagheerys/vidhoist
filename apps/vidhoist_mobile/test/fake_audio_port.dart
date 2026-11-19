import 'dart:async';

import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';

/// Builds a music player over [port] for a test: no file is checked and
/// no position is saved between tests.
VhAudioHandler fakeAudioHandler(FakeAudioPort port) {
  final store = MemoryKeyValueStore();
  final mutex = PrefsMutex();
  return VhAudioHandler(
    player: port,
    resolver: PlaybackSourceResolver(
      endpoint: ServerStreamEndpoint(
        buildUrl: (name) => 'https://srv/$name',
        headers: const {},
      ),
      fileExists: (_) => true,
    ),
    positions: PlaybackPositionStore(store: store, mutex: mutex),
    prefs: PlaybackPrefs(store: store, mutex: mutex),
    stateStore: AudioStateStore(store: store, mutex: mutex),
    saveInterval: const Duration(hours: 1),
  );
}

/// A player that plays nothing and says where it is when told to.
class FakeAudioPort implements MediaPlayerPort {
  final _events = StreamController<void>.broadcast();
  final _states = StreamController<MediaPlaybackState>.broadcast();
  final _errors = StreamController<Object>.broadcast();
  final _positions = StreamController<Duration>.broadcast();
  final calls = <String>[];

  void emit(Duration at) {
    position = at;
    _positions.add(at);
  }

  @override
  Duration position = Duration.zero;
  @override
  Duration bufferedPosition = Duration.zero;
  @override
  Duration? duration = const Duration(minutes: 3);
  @override
  double speed = 1;
  @override
  bool playing = false;
  @override
  MediaPlaybackState state = MediaPlaybackState.idle;

  @override
  Future<void> setSource(
    PlaybackSource source, {
    Duration initialPosition = Duration.zero,
  }) async {
    position = initialPosition;
    state = MediaPlaybackState.ready;
    _events.add(null);
  }

  @override
  Future<void> play() async {
    playing = true;
    _events.add(null);
  }

  @override
  Future<void> pause() async {
    playing = false;
    _events.add(null);
  }

  @override
  Future<void> stop() async {
    playing = false;
    state = MediaPlaybackState.idle;
    _events.add(null);
  }

  @override
  Future<void> seek(Duration to) async {
    position = to;
    calls.add('seek($to)');
  }

  @override
  Future<void> setSpeed(double value) async => speed = value;

  @override
  Stream<void> get events => _events.stream;
  @override
  Stream<MediaPlaybackState> get stateStream => _states.stream;
  @override
  Stream<Duration> get positionStream => _positions.stream;
  @override
  Stream<Object> get errors => _errors.stream;

  @override
  Future<void> dispose() async {
    await _events.close();
    await _states.close();
    await _errors.close();
    await _positions.close();
  }
}
