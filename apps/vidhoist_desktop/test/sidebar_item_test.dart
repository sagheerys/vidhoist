import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/shell/sidebar_items.dart';
import 'package:vh_ui/vh_ui.dart';

void main() {
  testWidgets('**the guard**: a full sidebar line squeezed mid-animation '
      'shows its icon alone rather than overflow', (tester) async {
    for (final width in [80.0, 100.0, 120.0, 140.0, 240.0]) {
      await tester.pumpWidget(
        VhDesktopApp(
          child: MaterialApp(
            theme: vhDesktopTheme(VhVariant.desktop, Brightness.light),
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: SidebarItem(
                    icon: VhIcons.folder,
                    label: 'Homelab recordings',
                    narrow: false,
                    selected: false,
                    depth: 2,
                    trailing: '128',
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: 'at $width');
    }
  });

  /// **The guard**: the place you are in shows its icon filled, as the
  /// phone's bar does; the others keep their outlines.
  testWidgets('a chosen place fills its icon, an unchosen one does not', (
    tester,
  ) async {
    Future<void> line({required bool selected}) => tester.pumpWidget(
      VhDesktopApp(
        child: MaterialApp(
          theme: vhDesktopTheme(VhVariant.desktop, Brightness.light),
          home: Scaffold(
            body: SizedBox(
              width: 240,
              child: SidebarItem(
                icon: VhIcons.library,
                selectedIcon: VhIcons.libraryFill,
                label: 'Library',
                narrow: false,
                selected: selected,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    Finder glyph(VhIconData icon) =>
        find.byWidgetPredicate((w) => w is VhIcon && w.icon == icon);

    await line(selected: false);
    await tester.pumpAndSettle();
    expect(glyph(VhIcons.library), findsOneWidget);
    expect(glyph(VhIcons.libraryFill), findsNothing);
    await line(selected: true);
    await tester.pumpAndSettle();
    expect(glyph(VhIcons.libraryFill), findsOneWidget);
    expect(glyph(VhIcons.library), findsNothing);
  });
}
