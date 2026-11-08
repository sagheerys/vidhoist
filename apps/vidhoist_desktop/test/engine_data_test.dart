import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/data/appearance_data.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/identity.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';

/// The app on the engine of this computer: what the engine options make
/// of yt-dlp's command, downloads recorded in the local history, the
/// library made of them, and unfinished ones taken up again at start.
void main() {
  group('the command each option makes', () {
    const paths = EnginePaths(
      ytDlp: r'C:\e\yt-dlp\yt-dlp.exe',
      ffmpeg: r'C:\e\ffmpeg\ffmpeg.exe',
      deno: r'C:\e\deno\deno.exe',
      managed: true,
    );

    test('no yt-dlp: nothing to run', () {
      expect(engineRunFor(const EnginePaths(), const EngineOptions()), isNull);
    });

    test('ffmpeg by its folder, Deno as the JavaScript runtime, IPv4', () {
      final run = engineRunFor(paths, const EngineOptions())!;
      expect(run.ytDlp, paths.ytDlp);
      expect(run.setup.platform, HostPlatform.windows);
      expect(run.setup.ffmpegDir, r'C:\e\ffmpeg');
      expect(run.setup.jsRuntime, r'deno:C:\e\deno\deno.exe');
      expect(run.setup.forceIpv4, isTrue);
      expect(run.deno, paths.deno);
    });

    test('IPv4 off, and the browser chosen over a cookies file', () {
      final run = engineRunFor(
        paths,
        const EngineOptions(
          forceIpv4: false,
          cookiesFile: r'C:\c.txt',
          cookiesBrowser: 'edge',
        ),
      )!;
      expect(run.setup.forceIpv4, isFalse);
      expect(run.setup.cookiesFromBrowser, 'edge');
      expect(run.setup.cookiesFile, isNull);
    });

    test('a cookies file alone is passed', () {
      final run = engineRunFor(
        paths,
        const EngineOptions(cookiesFile: r'C:\c.txt'),
      )!;
      expect(run.setup.cookiesFile, r'C:\c.txt');
    });
  });

  group('wiring', () {
    late Directory downloads;
    late MemoryKeyValueStore store;
    late FakeBackend backend;

    setUp(() async {
      downloads = await Directory.systemTemp.createTemp('vh_dl_');
      store = MemoryKeyValueStore();
      backend = FakeBackend();
    });
    tearDown(() => downloads.delete(recursive: true));

    ProviderContainer container({Duration folderDelay = Duration.zero}) {
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          desktopFoldersProvider.overrideWithValue(
            _Folders(downloads.path, delay: folderDelay),
          ),
          downloadBackendProvider.overrideWithValue(backend),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    /// A download that leaves its file where yt-dlp would.
    FakeScript writes(String name) => FakeScript(
      events: (request) {
        final file = File('${request.folder}${Platform.pathSeparator}$name')
          ..createSync(recursive: true)
          ..writeAsStringSync('media');
        return [BackendFinished(file.path)];
      },
    );

    Future<DownloadTask> finish(ProviderContainer c, DownloadTask task) => c
        .read(downloadEngineProvider)!
        .updates
        .firstWhere((t) => t.id == task.id && t.isFinished);

    test('options are kept and read back', () async {
      final c = container();
      await c.read(engineOptionsProvider.notifier).setForceIpv4(false);
      await c.read(engineOptionsProvider.notifier).setCookiesBrowser('firefox');
      final again = container();
      again.read(engineOptionsProvider);
      for (
        var i = 0;
        i < 100 && again.read(engineOptionsProvider).forceIpv4;
        i++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(again.read(engineOptionsProvider).forceIpv4, isFalse);
      expect(again.read(engineOptionsProvider).cookiesBrowser, 'firefox');
    });

    test('no backend: no engine', () {
      final c = ProviderContainer(
        overrides: [keyValueStoreProvider.overrideWithValue(store)],
      );
      addTearDown(c.dispose);
      expect(c.read(downloadEngineProvider), isNull);
    });

    test('a finished download is in the library, as a file here', () async {
      backend.scripts['https://example.com/a'] = writes('clip [a].mp4');
      final c = container();
      final folder = await c.read(downloadFolderProvider.future);
      final task = c
          .read(downloadEngineProvider)!
          .submit('https://example.com/a', Quality.best);
      final done = await finish(c, task);
      expect(done.phase, TaskPhase.completed);
      expect(backend.requests.single.folder, folder);
      final items = await c.read(libraryItemsProvider.future);
      expect(items.single.localPath, done.localPath);
      expect(items.single.title, 'Title of https://example.com/a');
    });

    test('the transcript is asked for in the language of the app and in '
        'never their machine translations', () async {
      backend.scripts['https://example.com/s'] = writes('s.mp4');
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          desktopFoldersProvider.overrideWithValue(_Folders(downloads.path)),
          downloadBackendProvider.overrideWithValue(backend),
          initialAppearanceProvider.overrideWithValue((
            theme: ThemeMode.system,
            locale: 'ar',
          )),
        ],
      );
      addTearDown(c.dispose);
      await c.read(downloadFolderProvider.future);
      final task = c
          .read(downloadEngineProvider)!
          .submit('https://example.com/s', Quality.best);
      await finish(c, task);
      expect(
        backend.requests.single.subtitleLanguages,
        SubtitleLanguages.patterns(['ar', 'en']),
      );
    });

    test('a clip in a chosen folder goes below the download folder', () async {
      backend.scripts['https://example.com/b'] = writes('b.mp4');
      final c = container();
      final folder = await c.read(downloadFolderProvider.future);
      final task = c
          .read(downloadEngineProvider)!
          .submit('https://example.com/b', Quality.best, folder: 'Kids');
      await finish(c, task);
      expect(
        backend.requests.single.folder,
        '$folder${Platform.pathSeparator}Kids',
      );
    });

    test('a file deleted outside the app leaves the library', () async {
      backend.scripts['https://example.com/a'] = writes('gone.mp4');
      final c = container();
      await c.read(downloadFolderProvider.future);
      final done = await finish(
        c,
        c
            .read(downloadEngineProvider)!
            .submit('https://example.com/a', Quality.best),
      );
      expect(await c.read(libraryItemsProvider.future), hasLength(1));
      File(done.localPath!).deleteSync();
      c.invalidate(localLibraryProvider);
      expect(await c.read(libraryItemsProvider.future), isEmpty);
    });

    test('what the last run left unfinished starts again', () async {
      await LocalPendingStore(store).put(
        DownloadTask(
          inputUrl: 'https://example.com/left',
          quality: Quality.q720,
        ),
      );
      backend.scripts['https://example.com/left'] = writes('left.mp4');
      final c = container();
      c.read(downloadEngineProvider);
      for (var i = 0; i < 300 && backend.requests.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(backend.requests.single.url, 'https://example.com/left');
      expect(backend.requests.single.quality, Quality.q720);
    });

    test('**the guard**: what is restored at launch waits for the download '
        'folder', () async {
      // 2026-11-06: restored before the folder was read, a download went to
      // the default Downloads\Vidhoist whatever folder had been chosen (and
      // this test's file landed in the real one).
      await LocalPendingStore(store).put(
        DownloadTask(
          inputUrl: 'https://example.com/late',
          quality: Quality.best,
        ),
      );
      backend.scripts['https://example.com/late'] = writes('late.mp4');
      final c = container(folderDelay: const Duration(milliseconds: 50));
      c.read(downloadEngineProvider);
      for (var i = 0; i < 300 && backend.requests.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(
        backend.requests.single.folder,
        '${downloads.path}\\${DesktopIdentity.displayName}',
      );
    });
  });
}

class _Folders extends NoFolders {
  _Folders(this.downloadsRoot, {this.delay = Duration.zero});

  final String downloadsRoot;
  final Duration delay;

  // The test's own folder stands for Downloads (the app adds VidHoist).
  @override
  Future<String?> downloads() async {
    await Future<void>.delayed(delay);
    return downloadsRoot;
  }
}
