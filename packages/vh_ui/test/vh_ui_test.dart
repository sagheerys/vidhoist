import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

void main() {
  group('vhTheme: the surfaceContainer* lesson', () {
    for (final variant in VhVariant.values) {
      for (final brightness in Brightness.values) {
        test(
          '${variant.name}/${brightness.name}: the five roles are assigned and distinct',
          () {
            final scheme = vhTheme(variant, brightness).colorScheme;
            final ramp = {
              scheme.surfaceContainerLowest,
              scheme.surfaceContainerLow,
              scheme.surfaceContainer,
              scheme.surfaceContainerHigh,
              scheme.surfaceContainerHighest,
            };
            expect(
              ramp,
              hasLength(5),
              reason: 'أي تطابق يعني سقوطاً لرماديات M3 الافتراضية',
            );
            expect(scheme.surface, VhPalette.of(variant, brightness).bg);
          },
        );
      }
    }

    test(
      'the accent colour: the Vidhoist blue, one pair for both variants',
      () {
        expect(
          vhTheme(VhVariant.desktop, Brightness.light).colorScheme.primary,
          const Color(0xFF2457D6),
        );
        expect(
          vhTheme(VhVariant.desktop, Brightness.dark).colorScheme.primary,
          const Color(0xFF7FA3FF),
        );
        expect(
          vhTheme(VhVariant.phone, Brightness.light).colorScheme.primary,
          const Color(0xFF2457D6),
        );
        expect(
          vhTheme(VhVariant.phone, Brightness.dark).colorScheme.primary,
          const Color(0xFF7FA3FF),
        );
      },
    );

    test('at night, text over the accent is dark, not white', () {
      for (final variant in VhVariant.values) {
        final onAccent = VhPalette.of(variant, Brightness.dark).onAccent;
        expect(onAccent.computeLuminance(), lessThan(0.1));
      }
    });

    test(
      'the favourite is a crimson of its own, independent of both accents',
      () {
        for (final variant in VhVariant.values) {
          final p = VhPalette.of(variant, Brightness.light);
          expect(p.favorite, const Color(0xFFA83A3A));
          expect(p.favorite, isNot(p.accent));
        }
      },
    );
  });

  group('VhGalleryScreen', () {
    Widget host(
      VhVariant variant,
      Brightness brightness,
      TextDirection direction,
    ) => MaterialApp(
      theme: vhTheme(variant, brightness),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      locale: Locale(direction == TextDirection.rtl ? 'ar' : 'en'),
      home: Directionality(
        textDirection: direction,
        child: const VhGalleryScreen(),
      ),
    );

    for (final variant in VhVariant.values) {
      for (final brightness in Brightness.values) {
        for (final direction in TextDirection.values) {
          testWidgets(
            'it draws without error: ${variant.name}/${brightness.name}/${direction.name}',
            (tester) async {
              // A tall surface, so every section of the lazy list is actually
              // built.
              tester.view.physicalSize = const Size(800, 3600);
              tester.view.devicePixelRatio = 1;
              addTearDown(tester.view.reset);
              await tester.pumpWidget(host(variant, brightness, direction));
              await tester.pump(const Duration(milliseconds: 50));
              expect(tester.takeException(), isNull);
              expect(find.byType(VhGalleryScreen), findsOneWidget);
              expect(find.byType(VhMediaCard), findsWidgets);
              expect(find.byType(VhDownloadProgressCard), findsNWidgets(2));
            },
          );
        }
      }
    }
  });

  group('VhMediaCard', () {
    testWidgets('tapping the heart calls the toggle', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: vhTheme(VhVariant.desktop, Brightness.light),
          // The card reads localisations for its button tooltips and its
          // screen-reader description (audit 8.1), so it needs the delegates
          // like any real screen.
          locale: const Locale('ar'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Scaffold(
            body: VhMediaCard(
              title: 'عنوان',
              favorite: true,
              onFavoriteToggle: () => toggled = true,
            ),
          ),
        ),
      );
      await tester.tap(byVhIcon(VhIcons.favoriteOn));
      expect(toggled, isTrue);
    });
  });

  group('VhLocalizations', () {
    test('Arabic and English are both supported', () {
      expect(
        VhLocalizations.supportedLocales.map((l) => l.languageCode),
        containsAll(['ar', 'en']),
      );
    });

    /// **Caught by hand on a device, 2026-09-08**: the delete-playlist
    /// dialog showed two visible backslashes around the playlist name,
    /// because the quote in the arb file was written as an escaped
    /// backslash-quote and JSON unescaped it into a backslash followed by a
    /// quote. Neither `analyze` nor the parity guard catches it: the JSON
    /// is valid and the key is translated in both languages. **Only the eye
    /// sees it**, and this guard now stands in for the eye.
    test('no stray slash visible in the confirmation strings', () async {
      for (final code in ['ar', 'en']) {
        final l10n = await VhLocalizations.delegate.load(Locale(code));
        for (final text in [
          l10n.deletePlaylistConfirm('س'),
          l10n.deleteVideoConfirm('س'),
          l10n.deleteTagConfirm('س'),
        ]) {
          expect(text, isNot(contains(r'\')), reason: '[$code] $text');
        }
      }
    });
  });
}
