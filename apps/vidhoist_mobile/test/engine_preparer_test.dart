import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/features/engine/engine_preparer.dart';
import 'package:vidhoist_mobile/features/engine/ytdlp_bridge.dart';

/// The library as the preparer sees it: init and update, scripted.
class _Bridge implements YtDlpBridge {
  var inits = 0;
  var updates = 0;
  Object? initError;
  Object? updateError;
  String? current;
  Completer<void>? initGate;

  @override
  Future<void> init() async {
    inits++;
    await initGate?.future;
    if (initError case final e?) throw e;
  }

  @override
  Future<String?> version() async => current;

  @override
  Future<({bool updated, String? version})> update({
    bool nightly = false,
  }) async {
    updates++;
    if (updateError case final e?) throw e;
    current = '2026.10.26';
    return (updated: true, version: current);
  }

  @override
  Future<BridgeRun> execute(
    String id,
    List<String> args, {
    String? stdoutFile,
  }) => throw UnimplementedError();

  @override
  Stream<({String id, String line})> get lines => const Stream.empty();

  @override
  Future<bool> cancel(String id) async => false;
}

void main() {
  late _Bridge bridge;
  late MemoryKeyValueStore store;
  var now = DateTime(2026, 11, 6, 12);

  EnginePreparer preparer() =>
      EnginePreparer(bridge: bridge, store: store, now: () => now);

  setUp(() {
    bridge = _Bridge();
    store = MemoryKeyValueStore();
    now = DateTime(2026, 11, 6, 12);
  });

  test('the first run unpacks, then updates: the bundled yt-dlp is a year '
      'old and fails on YouTube', () async {
    final p = preparer();
    final stages = <EngineStage>[];
    p.statuses.listen((s) {
      if (stages.lastOrNull != s.stage) stages.add(s.stage);
    });
    await p.ensure();
    await pumpEventQueue();
    expect(bridge.inits, 1);
    expect(bridge.updates, 1);
    expect(stages, [
      EngineStage.unpacking,
      EngineStage.updating,
      EngineStage.ready,
    ]);
    expect(p.status.version.toString(), '2026.10.26');
    expect(p.status.updatedAt, now);
  });

  test('once ready, it is not prepared again', () async {
    final p = preparer();
    await Future.wait([p.ensure(), p.ensure()]);
    await p.ensure();
    expect(bridge.inits, 1);
    expect(bridge.updates, 1);
  });

  test('a later launch updates only when a week has passed', () async {
    await preparer().ensure();
    now = now.add(const Duration(days: 3));
    await preparer().ensure();
    expect(bridge.updates, 1);
    now = now.add(const Duration(days: 5));
    await preparer().ensure();
    expect(bridge.updates, 2);
  });

  test('a failed first update does not stop the engine, and is tried again '
      'at the next need', () async {
    bridge.updateError = PlatformException(code: 'offline');
    final p = preparer();
    await p.ensure();
    expect(p.status.stage, EngineStage.ready);
    expect(p.status.updateFailed, isTrue);
    bridge.updateError = null;
    await p.ensure();
    expect(bridge.updates, 2);
    expect(p.status.updateFailed, isFalse);
    expect(bridge.inits, 1, reason: 'Python is unpacked once');
  });

  test('a failed unpacking is reported and tried again', () async {
    bridge.initError = PlatformException(code: 'init_failed', message: 'no');
    final p = preparer();
    await expectLater(p.ensure(), throwsA(isA<PlatformException>()));
    expect(p.status.stage, EngineStage.failed);
    bridge.initError = null;
    await p.ensure();
    expect(p.status.stage, EngineStage.ready);
    expect(bridge.inits, 2);
  });

  test('the update button updates now, and says whether it did', () async {
    final p = preparer();
    await p.ensure();
    now = now.add(const Duration(hours: 1));
    expect(await p.update(), isTrue);
    expect(bridge.updates, 2);
    expect(p.status.updatedAt, now);
    bridge.updateError = PlatformException(code: 'offline');
    expect(await p.update(), isFalse);
    expect(p.status.stage, EngineStage.ready);
    expect(p.status.updateFailed, isTrue);
  });
}
