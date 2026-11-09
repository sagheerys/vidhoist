import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/pending_recovery.dart';
import 'package:vidhoist_mobile/features/home/network_gate.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/storage/phone_volumes.dart';

/// The app runs on the phone's own engine: the settings reach each
/// download, a finished one is recorded on the phone, and what the last
/// run left unfinished comes back at launch.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late StreamController<List<ConnectivityResult>> network;

  ProviderContainer build(
    PhoneSettings settings, {
    bool onWifi = true,
    List<PhoneVolume> volumes = const [],
  }) {
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
          VhLogger(filePath: '${Directory.systemTemp.path}/vh_wiring.log'),
        ),
        networkGateProvider.overrideWithValue(gate),
        downloadBackendProvider.overrideWithValue(backend),
        initialVolumesProvider.overrideWithValue(volumes),
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

  test('**the guard**: downloads land in Download/VidHoist, never in '
      'another app\'s folder', () {
    // A shared folder would mix another app's files into the library. The
    // spelling follows the shown name since 2026-11-09; the old `Vidhoist`
    // is the same folder to Android (`media_folder_rename.dart`).
    expect(phoneMediaDir, '/storage/emulated/0/Download/VidHoist');
  });

  const card = PhoneVolume(
    id: '1A2B-3C4D',
    path: '/storage/1A2B-3C4D',
    label: 'SD card',
  );

  test('the chosen card takes the download while it is in', () async {
    final c = build(
      const PhoneSettings(downloadVolume: '1A2B-3C4D'),
      volumes: const [card],
    );
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(() => engine.taskById(task.id)!.isFinished);
    expect(
      backend.requests.single.folder,
      '/storage/1A2B-3C4D/Download/VidHoist',
    );
  });

  test('a chosen card that is out sends the download to the phone, not '
      'to a failure', () async {
    final c = build(const PhoneSettings(downloadVolume: '1A2B-3C4D'));
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(() => engine.taskById(task.id)!.isFinished);
    expect(backend.requests.single.folder, phoneMediaDir);
  });

  test('nothing to set up: the engine is always there', () {
    final c = build(const PhoneSettings());
    expect(c.read(downloadEngineProvider), isA<LocalDownloadEngine>());
  });

  test('a download that ends as the app closes records nothing more', () async {
    // CI, 2026-11-06: the after-download steps went on reading providers
    // once the container was gone, and failed after the test had passed.
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/vh_wiring.log'),
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
    final c = build(const PhoneSettings(compatiblePlayback: true));
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.q720);
    await until(() => engine.taskById(task.id)!.isFinished);
    final request = backend.requests.single;
    expect(request.compatible, isTrue);
    expect(request.subtitleLanguages, SubtitleLanguages.patterns(['ar', 'en']));
    expect(request.folder, phoneMediaDir);
  });

  test('a finished download is recorded on the phone', () async {
    final c = build(const PhoneSettings());
    final engine = c.read(downloadEngineProvider)!;
    final task = engine.submit('https://youtu.be/a', Quality.best);
    await until(() => engine.taskById(task.id)?.phase == TaskPhase.completed);
    final entries = await c.read(localHistoryProvider).entries();
    expect(entries.single.path, endsWith('${task.id}.mp4'));
  });

  test('"Wi-Fi only" on mobile data holds the start', () async {
    final c = build(const PhoneSettings(wifiOnly: true), onWifi: false);
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
    final c = build(const PhoneSettings());
    await c.read(pendingRecoveryProvider)();
    final engine = c.read(downloadEngineProvider)!;
    await until(() => engine.tasks.every((t) => t.isFinished));
    expect(backend.requests.single.url, 'https://youtu.be/left');
  });
}
