import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// The banner that offers a copied link: its margin sits on the side the
/// reading starts from, in both directions.
void main() {
  for (final direction in TextDirection.values) {
    testWidgets('**the guard**: the page margin before the icon, '
        '${direction.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Directionality(
            textDirection: direction,
            child: Scaffold(
              body: VhClipboardBanner(
                url: 'https://example.org/a',
                title: 'A link',
                downloadLabel: 'Download',
                optionsLabel: 'Options',
                onDownload: () {},
                onOptions: () {},
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );
      final banner = tester.getRect(find.byType(VhClipboardBanner));
      final icon = tester.getRect(
        find.byWidgetPredicate((w) => w is VhIcon && w.icon == VhIcons.link),
      );
      final margin = direction == TextDirection.rtl
          ? banner.right - icon.right
          : icon.left - banner.left;
      expect(margin, VhSpace.pagePad);
    });
  }
}
