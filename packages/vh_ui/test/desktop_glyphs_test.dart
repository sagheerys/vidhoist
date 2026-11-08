import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// The library's shared cards draw the app's icons on a phone and in the
/// Windows app alike, and no Material icon on either.
void main() {
  Widget cards() => ListView(
    children: [
      SizedBox(
        width: 240,
        child: VhMediaGridCard(title: 'Amber Skies', onFavoriteToggle: () {}),
      ),
      VhMediaCard(title: 'Amber Skies', audio: true, onFavoriteToggle: () {}),
      VhMediaRow(
        columns: const VhMediaColumns(),
        title: 'Amber Skies',
        favorite: true,
        onFavoriteToggle: () {},
      ),
    ],
  );

  Future<void> pump(WidgetTester tester, {required bool desktop}) async {
    final app = MaterialApp(
      theme: vhTheme(VhVariant.desktop, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      home: Scaffold(body: SizedBox(width: 900, child: cards())),
    );
    await tester.pumpWidget(desktop ? VhDesktopApp(child: app) : app);
  }

  testWidgets('**the guard**: a phone draws the app\'s icons too', (
    tester,
  ) async {
    await pump(tester, desktop: false);
    expect(byVhIcon(VhIcons.favorite), findsNWidgets(2));
    expect(byVhIcon(VhIcons.favoriteOn), findsOneWidget);
    expect(byVhIcon(VhIcons.music), findsWidgets);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('the Windows app draws no Material icon on them', (tester) async {
    await pump(tester, desktop: true);
    expect(find.byType(Icon), findsNothing);
    final names = [
      for (final i in tester.widgetList<VhIcon>(find.byType(VhIcon)))
        i.icon.name,
    ];
    expect(names, containsAll(['favorite_on', 'headphones', 'library']));
    // **The guard**: on a grid cover at rest only a favourite shows its
    // heart; the empty heart waits for the pointer.
    final onCover = [
      for (final i in tester.widgetList<VhIcon>(
        find.descendant(
          of: find.byType(VhMediaGridCard),
          matching: find.byType(VhIcon),
        ),
      ))
        i.icon.name,
    ];
    expect(onCover, isNot(contains('favorite')));
  });
}
