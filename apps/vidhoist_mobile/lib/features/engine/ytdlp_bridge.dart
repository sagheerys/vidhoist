import 'dart:async';

import 'package:flutter/services.dart';

/// How one yt-dlp run on the phone ended.
class BridgeRun {
  const BridgeRun({
    required this.exitCode,
    this.stderr = '',
    this.cancelled = false,
  });

  factory BridgeRun.fromMap(Map<Object?, Object?> map) => BridgeRun(
    exitCode: map['exitCode'] as int? ?? 1,
    stderr: map['stderr'] as String? ?? '',
    cancelled: map['cancelled'] == true,
  );

  final int exitCode;
  final String stderr;

  /// Stopped by [YtDlpBridge.cancel]: neither a result nor a failure.
  final bool cancelled;
}

/// youtubedl-android, as the Kotlin side (`YtDlpBridge.kt`) offers it.
///
/// Everything the library does is slow (unpacking Python takes seconds,
/// a YouTube probe nearly a minute), so every call runs on a thread of its
/// own there and answers here when done.
abstract interface class YtDlpBridge {
  /// Unpacks Python and ffmpeg the first time; quick afterwards.
  Future<void> init();

  /// yt-dlp's version, or null before its first update: the library does
  /// not know the version it ships with.
  Future<String?> version();

  /// Updates yt-dlp; true when a newer one was installed.
  Future<({bool updated, String? version})> update({bool nightly = false});

  /// Runs yt-dlp with [args], whole and in order. Each line it prints that
  /// starts with `[` comes on [lines] under [id] before the run answers.
  /// [stdoutFile] keeps everything it printed in that file (a probe's
  /// JSON, too large to send back).
  Future<BridgeRun> execute(String id, List<String> args, {String? stdoutFile});

  /// The lines of the runs, as `(id, line)`.
  Stream<({String id, String line})> get lines;

  /// Stops run [id] with its Python and ffmpeg; false when none was running.
  Future<bool> cancel(String id);
}

/// [YtDlpBridge] over a method channel for the calls and an event channel
/// for the lines.
class MethodChannelYtDlpBridge implements YtDlpBridge {
  MethodChannelYtDlpBridge();

  static const methods = MethodChannel('vidhoist/ytdlp');
  static const lineChannel = EventChannel('vidhoist/ytdlp/lines');

  /// One listener for the life of the app: every run's lines come through
  /// it, so a run never starts before its lines can be heard. Each run
  /// ends there with `{id, done: true}` after its last line.
  late final Stream<Map<Object?, Object?>> _events = lineChannel
      .receiveBroadcastStream()
      .map((event) => event as Map<Object?, Object?>)
      .asBroadcastStream();

  /// The reply and the lines travel on two channels, and nothing orders
  /// one against the other; a run is over once its end marker is heard
  /// too. Bounded, so a marker lost with a crashed run cannot hold it.
  static const _endWait = Duration(seconds: 3);

  @override
  Stream<({String id, String line})> get lines => _events
      .where((m) => m['line'] is String)
      .map((m) => (id: m['id'] as String, line: m['line'] as String));

  @override
  Future<void> init() => methods.invokeMethod<Object?>('init');

  @override
  Future<String?> version() => methods.invokeMethod<String>('version');

  @override
  Future<({bool updated, String? version})> update({
    bool nightly = false,
  }) async {
    final answer = await methods.invokeMapMethod<String, Object?>('update', {
      'channel': nightly ? 'nightly' : 'stable',
    });
    return (
      updated: answer?['status'] == 'DONE',
      version: answer?['version'] as String?,
    );
  }

  @override
  Future<BridgeRun> execute(
    String id,
    List<String> args, {
    String? stdoutFile,
  }) async {
    final ended = Completer<void>();
    final heard = _events.listen((m) {
      if (m['id'] == id && m['done'] == true && !ended.isCompleted) {
        ended.complete();
      }
    }, onError: (Object _) {});
    try {
      final answer = await methods.invokeMapMethod<Object?, Object?>(
        'execute',
        {'id': id, 'args': args, 'stdoutFile': ?stdoutFile},
      );
      await ended.future.timeout(_endWait, onTimeout: () {});
      return BridgeRun.fromMap(answer ?? const {});
    } finally {
      await heard.cancel();
    }
  }

  @override
  Future<bool> cancel(String id) async =>
      await methods.invokeMethod<bool>('cancel', {'id': id}) ?? false;
}
