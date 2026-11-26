import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/identity.dart';

/// The startup sweep of the partial files yt-dlp leaves behind, run on
/// the computer as on the phone.
void main() {
  late Directory downloads;
  late String root;
  late MemoryKeyValueStore store;

  setUp(() async {
    downloads = await Directory.systemTemp.createTemp('vh_sweep_');
    root = '${downloads.path}\\${DesktopIdentity.displayName}';
    store = MemoryKeyValueStore();
  });
  tearDown(() => downloads.delete(recursive: true));

  File put(String name, {bool old = true}) {
    final file = File('$root\\$name')
      ..createSync(recursive: true)
      ..writeAsStringSync('x');
    if (old) {
      file.setLastModifiedSync(
        DateTime.now().subtract(const Duration(days: 4)),
      );
    }
    return file;
  }

  test('**the guard**: at start the computer sweeps old partial files, and '
      'keeps fresh ones, finished files and those a paused download will '
      'continue from', () async {
    final old = put('Old [o1].mp4.part');
    final below = put('Kids\\Old [o2].f399.mp4.ytdl');
    final fresh = put('New [n1].mp4.part', old: false);
    final done = put('Done [d1].mp4');
    final paused = put('Paused [p1].f399.mp4.part');
    await LocalPendingStore(store).put(
      DownloadTask(
        inputUrl: 'https://example.com/p1',
        quality: Quality.best,
        phase: TaskPhase.paused,
        mediaId: 'p1',
      ),
    );
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        desktopFoldersProvider.overrideWithValue(_Folders(downloads.path)),
        downloadBackendProvider.overrideWithValue(FakeBackend()),
      ],
    );
    addTearDown(c.dispose);

    c.read(downloadEngineProvider);
    for (var i = 0; i < 300 && (old.existsSync() || below.existsSync()); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    expect(old.existsSync(), isFalse);
    expect(below.existsSync(), isFalse);
    expect(fresh.existsSync(), isTrue);
    expect(done.existsSync(), isTrue);
    expect(paused.existsSync(), isTrue);
  });
}

class _Folders extends NoFolders {
  const _Folders(this.downloadsRoot);

  final String downloadsRoot;

  // The test's own folder stands for Downloads (the app adds VidHoist).
  @override
  Future<String?> downloads() async => downloadsRoot;
}
