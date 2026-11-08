import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// **A heart on favourites alone** (owner's decision 2026-11-01): a phone
/// card no longer carries an empty heart to tap; a favourite shows a small
/// mark instead, and a card that keeps its toggle (the computer) is as it
/// was.
void main() {
  Widget host(Widget child) => MaterialApp(
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    locale: const Locale('en'),
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    home: Scaffold(
      body: Center(child: SizedBox(width: 640, child: child)),
    ),
  );

  const cover = ColoredBox(color: Colors.teal);
  void none() {}

  Map<String, Widget> cards({required bool favorite, VoidCallback? toggle}) => {
    'grid card': VhMediaGridCard(
      title: 'Song',
      subtitle: 'Band',
      thumbnail: cover,
      favorite: favorite,
      onTap: none,
      onFavoriteToggle: toggle,
    ),
    'list card': VhMediaCard(
      title: 'Song',
      subtitle: 'Band',
      thumbnail: cover,
      favorite: favorite,
      onTap: none,
      onFavoriteToggle: toggle,
    ),
    'table row': VhMediaRow(
      columns: const VhMediaColumns(),
      title: 'Song',
      subtitle: 'Band',
      thumbnail: cover,
      favorite: favorite,
      onTap: none,
      onFavoriteToggle: toggle,
    ),
  };

  for (final name in cards(favorite: false).keys) {
    testWidgets('**the guard**: a favourite $name with nothing to toggle '
        'shows the small mark and no button', (tester) async {
      await tester.pumpWidget(host(cards(favorite: true)[name]!));
      expect(find.byType(VhFavoriteMark), findsOneWidget);
      expect(find.byTooltip('Remove from favorites'), findsNothing);
    });

    testWidgets('**the guard**: a $name that is not a favourite shows no '
        'heart at all', (tester) async {
      await tester.pumpWidget(host(cards(favorite: false)[name]!));
      expect(find.byType(VhFavoriteMark), findsNothing);
      expect(byVhIcon(VhIcons.favorite), findsNothing);
    });

    testWidgets('a $name with a toggle keeps its heart button and no mark', (
      tester,
    ) async {
      await tester.pumpWidget(host(cards(favorite: true, toggle: none)[name]!));
      expect(find.byType(VhFavoriteMark), findsNothing);
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    });
  }

  testWidgets('the menu row and the player heart name the action', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        Column(
          children: [
            VhFavoriteTile(favorite: false, onTap: () => taps++),
            VhFavoriteButton(favorite: true, onPressed: () => taps++),
          ],
        ),
      ),
    );
    expect(find.text('Add to favorites'), findsOneWidget);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    await tester.tap(find.text('Add to favorites'));
    await tester.tap(find.byTooltip('Remove from favorites'));
    expect(taps, 2);
  });
}
