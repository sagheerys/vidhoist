import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/features/star/star_ask_corner.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

/// The star question on the computer: a card in the library's corner after
/// the third download that finished.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  final library = [
    LibraryItem(
      canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
      title: 'Amber Skies',
      timestamp: DateTime(2026, 10, 21),
      sizeBytes: 100,
    ),
  ];

  Future<(ShellHarness, List<String>)> open(WidgetTester tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final opened = <String>[];
    final h = ShellHarness(
      library: library,
      withEngine: true,
      overrides: [
        starPageOpenerProvider.overrideWithValue(
          (url) async => opened.add(url),
        ),
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    return (h, opened);
  }

  Future<void> finish(WidgetTester tester, ShellHarness h, int n) async {
    for (var i = 0; i < n; i++) {
      final task = DownloadTask(
        inputUrl: 'https://youtu.be/b$i',
        quality: Quality.best,
        title: 'Clip $i',
        phase: TaskPhase.downloading,
        progress: 0.5,
      );
      h.engine.put(task);
      await tester.pumpAndSettle();
      h.engine.finish(task);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('**the guard**: not before the third finished download, then '
      'in the corner; Esc puts it off', (tester) async {
    final (h, _) = await open(tester);
    await finish(tester, h, 2);
    expect(find.byType(VhStarAsk), findsNothing);
    await finish(tester, h, 1);
    expect(find.byType(VhStarAsk), findsOneWidget);
    expect(find.text(l.starAskTitle), findsOneWidget);
    // In the far corner, above the player bar, not across the library.
    final card = tester.getRect(find.byType(VhStarAsk));
    expect(card.right, greaterThan(1440 / 2));
    expect(card.width, lessThan(420));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(VhStarAsk), findsNothing);
    // The next one finished does not bring it straight back.
    await finish(tester, h, 1);
    expect(find.byType(VhStarAsk), findsNothing);
  });

  testWidgets('**the guard**: the star opens the repository and ends it', (
    tester,
  ) async {
    final (h, opened) = await open(tester);
    await finish(tester, h, 3);
    await tester.tap(find.text(l.starAskStar));
    await tester.pumpAndSettle();
    expect(opened, [StarAsk.repoUrl]);
    expect(find.byType(VhStarAsk), findsNothing);
    expect(await StarAsk(h.store).isDue(), isFalse);
    await finish(tester, h, 25);
    expect(find.byType(VhStarAsk), findsNothing);
  });

  testWidgets('ideas and problems open GitHub\'s forms', (tester) async {
    final (h, opened) = await open(tester);
    await finish(tester, h, 3);
    await tester.tap(find.text(l.starAskIdeas));
    await tester.pumpAndSettle();
    expect(opened, [StarAsk.ideasUrl]);
  });

  testWidgets('**the guard**: the card fits every window, both directions '
      'and every text size', (tester) async {
    await expectNoOverflow(tester, () {
      final h = ShellHarness(library: library, withEngine: true);
      // Three downloads finished before this window opened.
      h.store.setInt('star_ask_finished', StarAsk.first);
      return h.app();
    }, then: (tester) async => expect(find.byType(VhStarAsk), findsOneWidget));
  });
}
