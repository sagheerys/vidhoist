import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/choices_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/notices.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vh_core/vh_core.dart';

import 'support/shell_harness.dart';

/// Windows' notifications, recording what they were asked to show.
class _Notices implements NoticePort {
  final shown = <DesktopNotice>[];

  @override
  Future<void> show(DesktopNotice notice) async => shown.add(notice);
}

/// Explorer, recording what it was asked to show.
class _Folders extends NoFolders {
  final revealed = <String>[];

  @override
  Future<void> reveal(String path) async => revealed.add(path);
}

void main() {
  group('downloads', () {
    Future<(ShellHarness, _Notices)> open(
      WidgetTester tester, {
      bool inFront = false,
    }) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      final notices = _Notices();
      final h = ShellHarness(
        library: const [],
        withEngine: true,
        overrides: [
          noticePortProvider.overrideWithValue(notices),
          windowInFrontProvider.overrideWithValue(() async => inFront),
        ],
      );
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      return (h, notices);
    }

    testWidgets('**the guard**: a download done away from the window is '
        'announced with its title and Play; a failure says why', (
      tester,
    ) async {
      final (h, notices) = await open(tester);
      final done = h.engine.submit(
        'https://youtu.be/aaaaaaaaaaa',
        Quality.best,
      );
      final broken = h.engine.submit(
        'https://youtu.be/bbbbbbbbbbb',
        Quality.best,
      );
      await tester.pumpAndSettle();
      expect(notices.shown, isEmpty);

      h.engine.finish(
        done.copyWith(
          title: 'Night Drive',
          canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
        ),
      );
      h.engine.fail(
        broken.copyWith(title: 'Blue Hour'),
        const NetworkException('dropped'),
      );
      await tester.pumpAndSettle();
      final [ok, failed] = notices.shown;
      expect((ok.title, ok.body), ('Download complete', 'Night Drive'));
      expect([for (final a in ok.actions) a.label], ['Play']);
      expect(failed.title, 'Download failed');
      expect(failed.body, startsWith('Blue Hour · '));
      expect(failed.body, isNot(endsWith('Failed')));
    });

    // "Show in Explorer when done" followed the copies from a server; the
    // downloads made here are what it is about now.
    testWidgets('**the guard**: a finished download opens Explorer on its '
        'file when asked to, and not otherwise', (tester) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      final folders = _Folders();
      final store = MemoryKeyValueStore();
      await store.setBool(RevealAfterDownloadNotifier.key, true);
      final h = ShellHarness(
        library: const [],
        withEngine: true,
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          desktopFoldersProvider.overrideWithValue(folders),
        ],
      );
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      final task = h.engine.submit(
        'https://youtu.be/aaaaaaaaaaa',
        Quality.best,
      );
      final failed = h.engine.submit(
        'https://youtu.be/bbbbbbbbbbb',
        Quality.best,
      );
      await tester.pumpAndSettle();
      h.engine.finish(
        task.copyWith(localPath: r'C:\Downloads\Night Drive.mp4'),
      );
      h.engine.fail(failed, const NetworkException());
      await tester.pumpAndSettle();
      expect(folders.revealed, [r'C:\Downloads\Night Drive.mp4']);

      await store.setBool(RevealAfterDownloadNotifier.key, false);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      final quiet = h.engine.submit(
        'https://youtu.be/ccccccccccc',
        Quality.best,
      );
      await tester.pumpAndSettle();
      h.engine.finish(quiet.copyWith(localPath: r'C:\Downloads\Blue.mp4'));
      await tester.pumpAndSettle();
      expect(folders.revealed, hasLength(1));
    });

    testWidgets('**the guard**: with the window in front, the panel says it '
        'and no notice is shown', (tester) async {
      final (h, notices) = await open(tester, inFront: true);
      final task = h.engine.submit(
        'https://youtu.be/aaaaaaaaaaa',
        Quality.best,
      );
      await tester.pumpAndSettle();
      h.engine.finish(task);
      await tester.pumpAndSettle();
      expect(notices.shown, isEmpty);
    });
  });
}
