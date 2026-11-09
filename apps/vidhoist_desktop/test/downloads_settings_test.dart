import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_panel.dart';
import 'package:vidhoist_desktop/features/settings/folders_pane.dart';
import 'package:vidhoist_desktop/features/settings/pane_entry.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

class _Folders extends NoFolders {
  const _Folders();

  @override
  Future<String?> videos() async => r'C:\Users\me\Videos';

  @override
  Future<String?> downloads() async => r'C:\Users\me\Downloads';
}

const _reel = 'https://www.instagram.com/reel/abc/';

void main() {
  Future<ShellHarness> open(
    WidgetTester tester, {
    String? to,
    List<LibraryItem> library = const [],
  }) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
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
    final h = ShellHarness(
      library: library,
      withEngine: true,
      overrides: [
        desktopFoldersProvider.overrideWithValue(const _Folders()),
        // Logs reads its file; one that is never written is enough here.
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/ember_none.log'),
        ),
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    if (to != null) {
      GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(to);
      await tester.pumpAndSettle();
    }
    return h;
  }

  group('the downloads button and panel', () {
    testWidgets('counts what is under way, and the panel lets one go', (
      tester,
    ) async {
      final h = await open(tester);
      final task = h.engine.submit(_reel, Quality.best);
      await tester.pumpAndSettle();
      expect(byLabel('Downloads · 1 download in progress'), findsOneWidget);

      await tester.tap(byLabel('Downloads · 1 download in progress'));
      await tester.pumpAndSettle();
      final panel = find.byType(DownloadsPanel);
      expect(
        // The section, and the clip's own line.
        find.descendant(of: panel, matching: find.text('Waiting')),
        findsNWidgets(2),
      );
      await tester.tap(find.descendant(of: panel, matching: byLabel('Cancel')));
      await tester.pumpAndSettle();
      expect(h.engine.cancelled, [task.id]);
    });

    testWidgets('a failed clip is tried again from the panel', (tester) async {
      final h = await open(tester);
      final task = h.engine.submit(_reel, Quality.best);
      h.engine.fail(task, const NetworkException('dropped'));
      await tester.pumpAndSettle();
      await tester.tap(byLabel('Downloads'));
      await tester.pumpAndSettle();
      expect(find.text('Needs your attention'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(h.engine.submitted, hasLength(2));
      expect(h.engine.forgotten, [task.id]);
    });

    testWidgets('empty, it says how downloads begin, and offers nothing to '
        'hide even after a clip finished', (tester) async {
      final h = await open(tester);
      h.engine.finish(h.engine.submit(_reel, Quality.best));
      await tester.pumpAndSettle();
      await tester.tap(byLabel('Downloads'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing is downloading'), findsOneWidget);
      expect(find.text('Hide finished'), findsNothing);
    });
  });

  group('settings', () {
    testWidgets('the folders pane shows the download folder', (tester) async {
      await open(tester, to: '/settings/folders');
      expect(find.byType(FoldersPane), findsOneWidget);
      // **The guard** (owner's choice, 2026-11-05): the folder bears the
      // app's own name.
      expect(find.text(r'C:\Users\me\Downloads\VidHoist'), findsOneWidget);
      // There is no second folder, of offline copies, to show.
      expect(find.textContaining(r'Videos'), findsNothing);
    });

    testWidgets('**the guard**: "Change…" and "Open in Explorer" stand apart '
        'enough to read as two buttons', (tester) async {
      await open(tester, to: '/settings/folders');
      final change = tester.getRect(find.text('Change…').first);
      final open_ = tester.getRect(find.text('Open in Explorer').first);
      expect(open_.left - change.right, greaterThanOrEqualTo(VhSpace.lg));
    });

    testWidgets('**the guard**: every section has its row in the list', (
      tester,
    ) async {
      // The list is written by hand: a section added to the enum and the
      // pages but not here opened by its address only, and the owner found
      // no way to it (Phone, 2026-11-09).
      await open(tester, to: '/settings/subscriptions');
      final listed = {
        for (final entry in tester.widgetList<PaneEntry>(
          find.byType(PaneEntry, skipOffstage: false),
        ))
          entry.pane,
      };
      expect(listed, DesktopSettingsPane.values.toSet());
    });

    testWidgets('**the guard**: every section opens a page of its own, none '
        'says it comes later, and Playback is not offered', (tester) async {
      await open(tester, to: '/settings/subscriptions');
      // Playback's one choice on the phone works around an Android
      // decoder; the computer has nothing to put there.
      expect(
        DesktopSettingsPane.values.map((p) => p.name),
        isNot(contains('playback')),
      );
      expect(find.text('Playback'), findsNothing);
      for (final pane in DesktopSettingsPane.values) {
        GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(pane.route);
        await tester.pump();
        await tester.pump();
        expect(tester.takeException(), isNull, reason: pane.name);
        expect(find.textContaining('later'), findsNothing, reason: pane.name);
      }
    });
  });
}
