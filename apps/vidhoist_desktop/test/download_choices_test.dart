import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/download_choices_data.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/simple_panes.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';

import 'support/shell_harness.dart';

const _yt = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';
const _insta = 'https://www.instagram.com/reel/Cxyz123/';

/// The phone's download choices on the computer: a part of the video in
/// the add dialog, and Settings › Downloads' audio format, speed limit,
/// fast streams, subtitle languages and embedding, saved under the
/// phone's keys and read by the engine at each download.
void main() {
  void quietClipboard(WidgetTester tester) {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object?>{'text': ''}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
  }

  Future<ShellHarness> open(WidgetTester tester, {String? to}) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    quietClipboard(tester);
    final h = ShellHarness(library: const [], withEngine: true);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    if (to != null) {
      GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(to);
      await tester.pumpAndSettle();
    }
    return h;
  }

  group('a part of the video, in the add dialog', () {
    Future<ShellHarness> typed(
      WidgetTester tester,
      String from,
      String to,
    ) async {
      final h = await open(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopSidebar),
          matching: find.text('Add link'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, _yt);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Only a part of the video'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'From'), from);
      await tester.enterText(find.widgetWithText(TextField, 'To'), to);
      await tester.tap(find.widgetWithText(FilledButton, 'Start download'));
      await tester.pumpAndSettle();
      return h;
    }

    testWidgets('**the guard**: the stretch typed goes with the download', (
      tester,
    ) async {
      final h = await typed(tester, '130', '2:45');
      expect(
        h.engine.submitted.single.clip,
        const ClipRange(Duration(seconds: 90), Duration(seconds: 165)),
      );
    });

    // Seen: 10:00 to 20:00 was accepted for a 16:52 video, and yt-dlp then
    // failed with no reason a person could act on.
    testWidgets('**the guard**: a time past the video keeps the dialog '
        'open, naming its length', (tester) async {
      final h = await open(tester);
      h.engine.length = const Duration(minutes: 16, seconds: 52);
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopSidebar),
          matching: find.text('Add link'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, _yt);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Only a part of the video'));
      await tester.pumpAndSettle();
      expect(find.text('The video is 16:52 long'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'From'), '1000');
      await tester.enterText(find.widgetWithText(TextField, 'To'), '2000');
      await tester.tap(find.widgetWithText(FilledButton, 'Start download'));
      await tester.pumpAndSettle();
      expect(h.engine.submitted, isEmpty);
      expect(find.text('The video ends at 16:52'), findsOneWidget);
    });

    Future<ShellHarness> dialog(WidgetTester tester) async {
      final h = await open(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopSidebar),
          matching: find.text('Add link'),
        ),
      );
      await tester.pumpAndSettle();
      return h;
    }

    // Asked 2026-11-18: before the length came, any time could be typed.
    testWidgets('**the guard**: the length is read once the link stops '
        'changing, before a part is asked for', (tester) async {
      final h = await dialog(tester);
      await tester.enterText(find.byType(TextField).first, _yt);
      await tester.pump(const Duration(milliseconds: 300));
      expect(h.engine.lengthsAsked, isEmpty);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(h.engine.lengthsAsked, [_yt]);
    });

    testWidgets('**the guard**: Start pressed while it is read waits for '
        'it, and an end past it comes back to it', (tester) async {
      final h = await dialog(tester);
      final reading = h.engine.reading = Completer<Duration?>();
      await tester.enterText(find.byType(TextField).first, _yt);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Only a part of the video'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'From'), '1000');
      await tester.enterText(find.widgetWithText(TextField, 'To'), '2000');
      await tester.tap(find.widgetWithText(FilledButton, 'Start download'));
      await tester.pump();
      expect(find.text("Reading the video's length…"), findsOneWidget);
      expect(h.engine.submitted, isEmpty);

      reading.complete(const Duration(minutes: 16, seconds: 52));
      await tester.pumpAndSettle();
      expect(h.engine.submitted, isEmpty);
      expect(find.text('16:52'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Start download'));
      await tester.pumpAndSettle();
      expect(
        h.engine.submitted.single.clip,
        const ClipRange(
          Duration(minutes: 10),
          Duration(minutes: 16, seconds: 52),
        ),
      );
    });

    testWidgets('times that do not read keep the dialog open and say why', (
      tester,
    ) async {
      final h = await typed(tester, '2:00', '1:00');
      expect(h.engine.submitted, isEmpty);
      expect(find.text('After the start'), findsOneWidget);
    });

    testWidgets("the keyboard's ↑ ↓ step a minute, \"to\" from \"from\"", (
      tester,
    ) async {
      await typed(tester, '1:30', '');
      await tester.tap(find.widgetWithText(TextField, 'To'));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(find.text('2:30'), findsOneWidget);
    });

    testWidgets('not offered for several links', (tester) async {
      await open(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopSidebar),
          matching: find.text('Add link'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '$_yt\n$_insta');
      await tester.pumpAndSettle();
      expect(find.text('Only a part of the video'), findsNothing);
    });
  });

  group('Settings › Downloads', () {
    Finder switchOf(String title) => find.descendant(
      of: find.widgetWithText(SwitchLine, title),
      matching: find.byType(VhSwitch),
    );

    testWidgets('the choices are saved under the phone\'s keys', (
      tester,
    ) async {
      final h = await open(tester, to: '/settings/downloads');
      await tester.tap(find.text('MP3: for older players and cars'));
      await tester.tap(find.text('2 MB/s'));
      await tester.tap(switchOf('Faster segmented streams'));
      await tester.pumpAndSettle();
      expect(await h.store.getString(DownloadChoices.audioFormatKey), 'mp3');
      expect(await h.store.getString(DownloadChoices.rateLimitKey), '2M');
      expect(await h.store.getBool(DownloadChoices.fastStreamsKey), isTrue);
      await tester.tap(find.text('No limit'));
      await tester.pumpAndSettle();
      expect(await h.store.getString(DownloadChoices.rateLimitKey), isNull);
    });

    testWidgets('the languages start from the reader\'s, and leave with the '
        'transcript', (tester) async {
      final h = await open(tester, to: '/settings/downloads');
      await tester.ensureVisible(find.text('العربية'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();
      expect(await h.store.getStringList(DownloadChoices.subtitleLangsKey), [
        'en',
        'ar',
      ]);
      await tester.ensureVisible(switchOf('Fetch its transcript first'));
      await tester.tap(switchOf('Fetch its transcript first'));
      await tester.pumpAndSettle();
      expect(find.text('العربية'), findsNothing);
      expect(find.text('Subtitles inside the video too'), findsNothing);
    });
  });

  group('the engine reads them', () {
    late Directory downloads;
    late MemoryKeyValueStore store;
    late FakeBackend backend;

    setUp(() async {
      downloads = await Directory.systemTemp.createTemp('vh_choices_');
      store = MemoryKeyValueStore();
      backend = FakeBackend();
    });
    tearDown(() => downloads.delete(recursive: true));

    Future<DownloadRequest> sent(ClipRange? clip) async {
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          desktopFoldersProvider.overrideWithValue(_Folders(downloads.path)),
          downloadBackendProvider.overrideWithValue(backend),
        ],
      );
      addTearDown(c.dispose);
      c
        ..read(downloadChoicesProvider)
        ..read(transcriptsFirstProvider);
      await c.read(downloadFolderProvider.future);
      await pumpEventQueue();
      c.read(downloadEngineProvider)!.submit(_yt, Quality.best, clip: clip);
      for (var i = 0; i < 200 && backend.requests.isEmpty; i++) {
        await pumpEventQueue();
      }
      return backend.requests.single;
    }

    // Before this the computer built its engine with no tuning at all: the
    // choices could be set and the downloads would not have heard of them.
    test('**the guard**: each download carries the choices', () async {
      await store.setString(DownloadChoices.audioFormatKey, 'mp3');
      await store.setString(DownloadChoices.rateLimitKey, '5M');
      await store.setBool(DownloadChoices.fastStreamsKey, true);
      await store.setBool(DownloadChoices.embedSubtitlesKey, true);
      await store.setStringList(DownloadChoices.subtitleLangsKey, ['fr']);
      final request = await sent(null);
      expect(request.tuning.audioFormat, AudioFormat.mp3);
      expect(request.tuning.rateLimit, '5M');
      expect(request.tuning.concurrentFragments, DownloadChoices.fastPieces);
      expect(request.tuning.embedSubtitles, isTrue);
      expect(request.subtitleLanguages, SubtitleLanguages.patterns(['fr']));
    });

    test('with the transcript off, nothing is embedded', () async {
      await store.setBool(transcriptsFirstKey, false);
      await store.setBool(DownloadChoices.embedSubtitlesKey, true);
      final request = await sent(null);
      expect(request.tuning.embedSubtitles, isFalse);
      expect(request.subtitleLanguages, isEmpty);
    });

    test('a stretch reaches yt-dlp, without subtitles', () async {
      const clip = ClipRange(Duration(minutes: 1), Duration(minutes: 2));
      final request = await sent(clip);
      expect(request.clip, clip);
      expect(request.toSpec().subtitleLanguages, isEmpty);
    });
  });
}

class _Folders extends NoFolders {
  _Folders(this.downloadsRoot);

  final String downloadsRoot;

  @override
  Future<String?> downloads() async => downloadsRoot;
}
