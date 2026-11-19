import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/network_gate.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

/// "Wi-Fi only" on the phone: a download that loses Wi-Fi is
/// paused, not cancelled, and goes on by itself when Wi-Fi comes back.
void main() {
  late StreamController<List<ConnectivityResult>> network;
  late FakeBackend backend;
  late LocalDownloadEngine engine;
  late ProviderContainer c;

  Future<void> until(bool Function() done) async {
    for (var i = 0; i < 200 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  setUp(() async {
    network = StreamController.broadcast();
    backend = FakeBackend(hold: true);
    engine = LocalDownloadEngine(
      backend: backend,
      folderFor: (_) => Directory.systemTemp.path,
    );
    final gate = NetworkGate(
      changes: network.stream,
      check: () async => [ConnectivityResult.wifi],
    );
    c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        initialSettingsProvider.overrideWithValue(
          const PhoneSettings(wifiOnly: true),
        ),
        networkGateProvider.overrideWithValue(gate),
        downloadEngineProvider.overrideWithValue(engine),
      ],
    );
    await gate.start();
    c.read(wifiPauseProvider);
  });

  tearDown(() async {
    c.dispose();
    await network.close();
  });

  test('losing Wi-Fi pauses the download, and Wi-Fi back resumes it', () async {
    final task = engine.submit('https://youtu.be/abc', Quality.best);
    await until(() => backend.isHeld(task.id));
    expect(engine.taskById(task.id)!.phase, TaskPhase.downloading);

    network.add([ConnectivityResult.mobile]);
    await until(() => engine.taskById(task.id)!.phase == TaskPhase.paused);
    expect(engine.taskById(task.id)!.phase, TaskPhase.paused);
    expect(c.read(wifiPausedProvider), {task.id});

    network.add([ConnectivityResult.wifi]);
    await until(() => backend.requests.length == 2);
    expect(backend.requests, hasLength(2), reason: 'downloading again');
    expect(c.read(wifiPausedProvider), isEmpty);
  });

  test(
    'a download paused by hand stays paused when Wi-Fi comes back',
    () async {
      final task = engine.submit('https://youtu.be/abc', Quality.best);
      await until(() => backend.isHeld(task.id));
      engine.pause(task.id);
      network.add([ConnectivityResult.mobile]);
      await pumpEventQueue();
      network.add([ConnectivityResult.wifi]);
      await pumpEventQueue();
      expect(engine.taskById(task.id)!.phase, TaskPhase.paused);
    },
  );

  test('without "Wi-Fi only" nothing pauses', () async {
    await c.read(settingsProvider.notifier).setWifiOnly(false);
    final task = engine.submit('https://youtu.be/abc', Quality.best);
    await until(() => backend.isHeld(task.id));
    network.add([ConnectivityResult.mobile]);
    await pumpEventQueue();
    expect(engine.taskById(task.id)!.phase, TaskPhase.downloading);
  });
}
