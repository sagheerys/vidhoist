import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/library_cards.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'widget_test.dart' show host;

import 'icon_finder.dart';

/// **Favourites from the menu, not an empty heart on every card** (owner's
/// decision 2026-11-01).
void main() {
  LocalItem clip({bool favorite = false}) => LocalItem(
    key: 'https://youtu.be/a',
    path: '$phoneMediaDir/a.mp4',
    canonicalUrl: 'https://youtu.be/a',
    title: 'Clip',
    sizeBytes: 10,
    modified: DateTime(2026),
    favorite: favorite,
  );

  Future<void> pump(WidgetTester tester, LocalItem item) async {
    await tester.pumpWidget(
      host(
        LibraryItemCard(item: item, onPlay: () {}, onClearHighlight: () {}),
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          secretStoreProvider.overrideWithValue(MemorySecretStore()),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          localMediaProvider.overrideWith((ref) async => [item]),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: a card carries no heart to tap', (tester) async {
    await pump(tester, clip());
    expect(byVhIcon(VhIcons.favorite), findsNothing);
    expect(find.byType(VhFavoriteMark), findsNothing);
  });

  testWidgets('a favourite card shows the small mark', (tester) async {
    await pump(tester, clip(favorite: true));
    expect(find.byType(VhFavoriteMark), findsOneWidget);
  });

  testWidgets('**the guard**: the item menu opens on the favourite row', (
    tester,
  ) async {
    await pump(tester, clip());
    await tester.tap(byVhIcon(VhIcons.moreVert));
    await tester.pumpAndSettle();
    expect(find.byType(VhFavoriteTile), findsOneWidget);
  });

  testWidgets('**the guard**: the delete confirmation shows the clip itself', (
    tester,
  ) async {
    await pump(tester, clip());
    await tester.tap(byVhIcon(VhIcons.moreVert));
    await tester.pumpAndSettle();
    final delete = find.text('حذف الفيديو');
    await tester.ensureVisible(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(find.byType(VhConfirmDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(VhDialogClip),
        matching: find.textContaining('Clip'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();
  });
}
