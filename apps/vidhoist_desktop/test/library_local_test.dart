import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_panel.dart';
import 'package:vidhoist_desktop/features/library/first_link.dart';
import 'package:vidhoist_desktop/features/library/pending_clip.dart';

import 'support/shell_harness.dart';

const _yt = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';

final _held = LibraryItem(
  canonicalUrl: 'https://youtu.be/bbbbbbbbbbb',
  title: 'Amber Skies',
  timestamp: DateTime(2026, 10, 21),
  sizeBytes: 100,
);

void main() {
  final l = lookupVhLocalizations(const Locale('en'));

  Future<ShellHarness> open(
    WidgetTester tester, {
    List<LibraryItem> library = const [],
    String clipboard = '',
  }) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object?>{'text': clipboard}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final h = ShellHarness(library: library, withEngine: true);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    return h;
  }

  DownloadTask fetching(String title, {double progress = 0.38}) => DownloadTask(
    inputUrl: _yt,
    quality: Quality.best,
    title: title,
    phase: TaskPhase.downloading,
    progress: progress,
  );

  group('an empty library', () {
    testWidgets('**the guard**: it asks for the first link in place, with '
        'nothing to filter or lay out yet', (tester) async {
      await open(tester);
      expect(find.text(l.desktopFirstLinkTitle), findsOneWidget);
      expect(find.byType(FirstLink), findsOneWidget);
      // Filters and layouts for a library of nothing were noise.
      expect(find.text('Audio'), findsNothing);
      expect(find.bySemanticsLabel('Grid'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('^Sort by')), findsNothing);
    });

    testWidgets('its field opens the add dialog with the clipboard\'s link', (
      tester,
    ) async {
      await open(tester, clipboard: 'look: $_yt');
      await tester.tap(find.byType(FirstLink).hitTestable().first);
      await tester.pumpAndSettle();
      expect(find.text('Add URL'), findsOneWidget);
      expect(find.text('look: $_yt'), findsOneWidget);
    });
  });

  group('a clip on its way', () {
    testWidgets('**the guard**: it stands in the library at once, with what '
        'is happening to it, before the file is whole', (tester) async {
      final h = await open(tester, library: [_held]);
      h.engine.put(fetching('Field Notes'));
      await tester.pumpAndSettle();
      expect(find.byType(PendingClipView), findsOneWidget);
      expect(find.text(vhName('Field Notes')), findsOneWidget);
      expect(find.text(l.engineDownloadingProgress(38)), findsOneWidget);
      // First, ahead of what has arrived, and counted beside the clips.
      expect(
        tester.getTopLeft(find.text(vhName('Field Notes'))).dx,
        lessThan(tester.getTopLeft(find.text('Amber Skies')).dx),
      );
      expect(find.textContaining(l.desktopLibraryDownloading(1)), findsOne);
    });

    testWidgets('in an empty library it takes the first link\'s place', (
      tester,
    ) async {
      final h = await open(tester);
      h.engine.put(fetching('Field Notes'));
      await tester.pumpAndSettle();
      expect(find.byType(FirstLink), findsNothing);
      expect(find.byType(PendingClipView), findsOneWidget);
    });

    testWidgets('a click opens the downloads, where it can be stopped', (
      tester,
    ) async {
      final h = await open(tester, library: [_held]);
      h.engine.put(fetching('Field Notes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(vhName('Field Notes')));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadsPanel), findsOneWidget);
      expect(h.player.calls, isEmpty);
    });

    testWidgets('**the guard**: before its title comes it is called by its '
        'site, not by its whole link', (tester) async {
      final h = await open(tester, library: [_held]);
      h.engine.put(
        DownloadTask(
          inputUrl: _yt,
          quality: Quality.best,
          phase: TaskPhase.queued,
        ),
      );
      await tester.pumpAndSettle();
      final card = find.byType(PendingClipView);
      expect(
        find.descendant(of: card, matching: find.text(vhName('YouTube'))),
        findsOneWidget,
      );
      expect(
        find.descendant(of: card, matching: find.textContaining('https://')),
        findsNothing,
      );
      // A site the app has no name for goes by its address's host.
      final other = DownloadTask(
        inputUrl: 'https://www.example.org/v/1',
        quality: Quality.best,
      );
      expect(pendingName(other), 'example.org');
      expect(pendingName(fetching('Field Notes')), 'Field Notes');
    });

    testWidgets('**the guard**: a filter hides it, and a finished or '
        'cancelled one is not shown twice', (tester) async {
      final h = await open(tester, library: [_held]);
      final task = fetching('Field Notes');
      h.engine.put(task);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Audio'));
      await tester.pumpAndSettle();
      // Nothing is known yet of its kind, site or tags.
      expect(find.byType(PendingClipView), findsNothing);
      await tester.tap(find.text('Audio'));
      await tester.pumpAndSettle();
      expect(find.byType(PendingClipView), findsOneWidget);

      h.engine.finish(task);
      await tester.pumpAndSettle();
      expect(find.byType(PendingClipView), findsNothing);
      h.engine.put(fetching('Second'));
      await tester.pumpAndSettle();
      final second = h.engine.tasks.firstWhere((t) => t.title == 'Second');
      h.engine.cancel(second.id);
      await tester.pumpAndSettle();
      expect(find.byType(PendingClipView), findsNothing);
    });
  });
}
