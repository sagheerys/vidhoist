import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/clip_handover.dart';
import 'package:vidhoist_desktop/features/library/item_menu.dart';
import 'package:vidhoist_desktop/features/library/library_item_view.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

LibraryItem _clip({String? localPath}) => LibraryItem(
  canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
  title: 'Night Drive',
  localPath: localPath,
  timestamp: DateTime(2026, 10, 20),
);

void main() {
  group('what the menu offers, by the clip', () {
    final l = lookupVhLocalizations(const Locale('en'));
    List<ItemChoice?> choices(LibraryItem item, {bool hasFile = false}) => [
      for (final e in itemMenuEntries(l, item, hasFile: hasFile).skip(5))
        e.value,
    ];

    test('playing comes first, each with its key, apart from the rest', () {
      final entries = itemMenuEntries(l, _clip(), hasFile: false);
      expect(
        [for (final e in entries.take(5)) e.value],
        [
          ItemChoice.play,
          ItemChoice.playNext,
          ItemChoice.readingRoom,
          ItemChoice.favorite,
          null,
        ],
      );
      expect([
        for (final e in entries.take(4)) e.shortcut,
      ], everyElement(isNotNull));
    });

    test('a clip whose file is gone offers nothing to copy, show or '
        'delete', () {
      expect(choices(_clip()), [
        ItemChoice.copyLink,
        ItemChoice.openOriginal,
        ItemChoice.addToList,
        ItemChoice.tags,
      ]);
    });

    test("**the guard**: then the phone's order, and deleting its file last, "
        'apart and in the error colour; no server action is offered', () {
      final file = _clip(localPath: r'C:\x.mp4');
      expect(choices(file, hasFile: true), [
        ItemChoice.copyLink,
        ItemChoice.copyFile,
        ItemChoice.showInFolder,
        // Another player of the user's choice, for the file on this
        // computer.
        ItemChoice.openWith,
        ItemChoice.openOriginal,
        ItemChoice.addToList,
        ItemChoice.tags,
        null,
        ItemChoice.deleteLocal,
      ]);
      expect(itemMenuEntries(l, file, hasFile: true).last.danger, isTrue);
    });
  });

  group('in the library', () {
    Future<ShellHarness> open(
      WidgetTester tester, {
      List<LibraryItem>? dragged,
      List<LibraryItem>? library,
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
        library: library ?? [_clip()],
        withEngine: true,
        overrides: [
          if (dragged != null)
            clipDragProvider.overrideWithValue((item, child) {
              dragged.add(item);
              return child;
            }),
        ],
      );
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      return h;
    }

    Future<void> rightClick(WidgetTester tester, Finder on) async {
      await tester.tapAt(
        tester.getCenter(on),
        buttons: kSecondaryMouseButton,
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('**the guard**: a right click on a card opens its menu, and '
        'deleting asks first', (tester) async {
      await open(tester, library: [_clip(localPath: r'C:\x.mp4')]);
      await rightClick(tester, find.text('Night Drive'));
      expect(find.text('Copy link'), findsOneWidget);
      expect(find.text('Delete from server'), findsNothing);
      await tester.tap(find.text('Delete clip'));
      await tester.pumpAndSettle();
      // Cancelled: nothing goes.
      expect(find.textContaining('remove the file'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Night Drive'), findsOneWidget);
    });

    for (final arabic in [false, true]) {
      testWidgets('**the guard**: the menu opens on the reading side of the '
          'pointer (${arabic ? 'left, in Arabic' : 'right, in English'})', (
        tester,
      ) async {
        if (arabic) ShellHarness.useArabic(tester);
        // A row of cards across the window; the pointer goes on the one in
        // the half where Flutter alone would open the menu the wrong way.
        await open(
          tester,
          library: [
            for (var i = 0; i < 4; i++)
              LibraryItem(
                canonicalUrl: 'https://youtu.be/clip$i',
                title: 'Clip $i',
                serverFilename: 'Clip $i.mp4',
                timestamp: DateTime(2026, 10, 20),
              ),
          ],
        );
        final cards = [
          for (final e in find.byType(LibraryItemView).evaluate())
            tester.getRect(find.byWidget(e.widget)),
        ]..sort((a, b) => a.left.compareTo(b.left));
        // The second card from the far edge: in the half where Flutter
        // alone would open the menu backwards, yet with room for it before
        // the content's edge turns it back.
        final at = (arabic ? cards[1] : cards[cards.length - 2]).center;
        await tester.tapAt(
          at,
          buttons: kSecondaryMouseButton,
          kind: PointerDeviceKind.mouse,
        );
        await tester.pumpAndSettle();
        final menu = tester.getRect(
          find.byType(PopupMenuItem<ItemChoice>).first,
        );
        if (arabic) {
          expect(menu.right, lessThanOrEqualTo(at.dx + 1));
        } else {
          expect(menu.left, greaterThanOrEqualTo(at.dx - 1));
        }
      });
    }

    testWidgets('**the guard**: every clip in the library can be dragged out', (
      tester,
    ) async {
      final dragged = <LibraryItem>[];
      await open(tester, dragged: dragged);
      expect([
        for (final i in dragged) i.canonicalUrl,
      ], contains('https://youtu.be/aaaaaaaaaaa'));
    });
  });
}
