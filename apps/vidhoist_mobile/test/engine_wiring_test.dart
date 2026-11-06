import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/pending_recovery.dart';
import 'package:vidhoist_mobile/features/home/network_gate.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

/// The app runs on the phone's own engine: the settings reach each
/// download, a finished one is recorded on the phone, and what the last
/// run left unfinished comes back at launch.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late StreamController<List<ConnectivityResult>> network;

  ProviderContainer build(LiteSettings settings, {bool onWifi = true}) {
    final gate = NetworkGate(
      changes: network.stream,
      check: () async => [
        onWifi ? ConnectivityResult.wifi : ConnectivityResult.mobile,
      ],
    );
    unawaited(gate.start());
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        initialSettingsProvider.overrideWithValue(settings),
        loggerProvider.overrideWithValue(
          MTLogger(filePath: '${Directory.systemTemp.path}/vh_wiring.log'),
        ),
        networkGateProvider.overrideWithValue(gate),
        downloadBackendProvider.overrideWithValue(backend),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<void> until(bool Function() done) async {
    for (var i = 0; i < 200 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  setUp(() {
    store = MemoryKeyValueStore();
    backend = FakeBackend();
    network = StreamController.broadcast();
    addTearDown(network.close);
  });

  test('**the guard**: downloads land in Download/Vidhoist, never in the '
      'parent app\'s folder', () {
    // The fork kept Vidhoist Lite's folder; on a phone with both apps the two
    // libraries would have mixed.
    expect(liteMediaDir, '/storage/emulated/0/Download/Vidhoist');
  });

  test('no server is needed: the engine is always there', () {
    final c = build(const LiteSettings());
    expect(c.read(apiClientProvider), isNull);
    expect(c.read(downloadEngineProvider), isA<LocalDownloadEngine>());
  });

  test('a download that ends as the app closes records nothing more', () async {
    // CI, 2026-11-06: the after-download steps went on reading providers
    // once the container was gone, and failed after the test had passed.
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        initialSettingsProvider.overrideWithValue(const LiteSettings()),
        loggerProvider.overrideWithValue(
          MTLogger(filePath: '${Directory.systemTemp.path}/vh_wiring.log'),
        ),
        downloadBackendProvider.overrideWithValue(backend),
      ],
    );
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(() => engine.taskById(task.id)!.isFinished);
    c.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });

  test('the settings reach the download, into the media folder', () async {
    final c = build(const LiteSettings(compatiblePlayback: true));
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.q720);
    await until(() => engine.taskById(task.id)!.isFinished);
    final request = backend.requests.single;
    expect(request.compatible, isTrue);
    expect(request.subtitleLanguages, ['ar.*', 'en.*']);
    expect(request.folder, liteMediaDir);
  });

  test('a finished download is recorded on the phone', () async {
    final c = build(const LiteSettings());
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(() => engine.taskById(task.id)?.phase == TaskPhase.completed);
    final entries = await c.read(localHistoryProvider).entries();
    expect(entries.single.path, endsWith('${task.id}.mp4'));
  });

  test('"Wi-Fi only" on mobile data holds the start', () async {
    final c = build(const LiteSettings(wifiOnly: true), onWifi: false);
    await pumpEventQueue();
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(
      () => engine.taskById(task.id)?.phase == TaskPhase.waitingForNetwork,
    );
    expect(engine.taskById(task.id)!.phase, TaskPhase.waitingForNetwork);
    expect(backend.requests, isEmpty);
  });

  test('what the last run left unfinished is queued again at launch', () async {
    await LocalPendingStore(store).put(
      DownloadTask(inputUrl: 'https://youtu.be/left', quality: Quality.best),
    );
    final c = build(const LiteSettings());
    await c.read(pendingRecoveryProvider)();
    final engine = c.read(downloadEngineProvider)!;
    await until(() => engine.tasks.every((t) => t.isFinished));
    expect(backend.requests.single.url, 'https://youtu.be/left');
  });
}
