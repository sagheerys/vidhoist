import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/settings/about_screen.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'device_matrix.dart';

/// **The About screen names the licence and its sources.**
///
/// "All rights reserved" would contradict GPL-3.0, a missing disclaimer of
/// affiliation would mislead, and a build number `+1` means nothing to the
/// user.
void main() {
  setUp(
    () => PackageInfo.setMockInitialValues(
      appName: 'VidHoist',
      packageName: 'com.yasir.vidhoist',
      version: '2.0.0',
      buildNumber: '7',
      buildSignature: '',
    ),
  );

  Widget host() => MaterialApp(
    theme: vhTheme(VhVariant.phone, Brightness.light),
    locale: const Locale('ar'),
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    home: const AboutScreen(),
  );

  /// **A tall test surface**: the `ListView` is lazy and About's last
  /// sections are not built at all at 600 points, so searching for them
  /// fails without anything being wrong with the screen.
  Future<void> open(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 2600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
  }

  testWidgets('the version, without the build number', (tester) async {
    await open(tester);
    final l10n = tester.element(find.byType(AboutScreen)).vhl;

    expect(find.text('${l10n.version} 2.0.0'), findsOneWidget);
    // **The guard**: the text used to be `2.0.0+7`, and the build number is
    // an internal Android counter.
    expect(find.textContaining('+7'), findsNothing);
  });

  testWidgets(
    'the licence, the non-affiliation notice and the warranty disclaimer are shown',
    (tester) async {
      await open(tester);
      final l10n = tester.element(find.byType(AboutScreen)).vhl;

      expect(find.text(l10n.licensedUnder), findsOneWidget);
      expect(find.text(l10n.notAffiliated), findsOneWidget);
      expect(find.text(l10n.noWarranty), findsOneWidget);
      expect(find.text(l10n.copyright), findsOneWidget);
    },
  );

  testWidgets('the project links and what it is built on are present', (
    tester,
  ) async {
    await open(tester);

    expect(find.text(vhLtrRun('sagheerys/vidhoist')), findsOneWidget);
    expect(find.text(vhLtrRun('vidhoist/issues')), findsOneWidget);
    expect(
      find.textContaining(
        RegExp(
          'Me'
          'Tube',
        ),
      ),
      findsNothing,
    );
    expect(find.text('yt-dlp'), findsOneWidget);
  });

  testWidgets('**the guard**: in Arabic a link sits under its title, on '
      'the side of its title, not against the far edge', (tester) async {
    await open(tester);
    for (final (title, link) in [
      ('X', 'x.com/Sagheer700'),
      (
        lookupVhLocalizations(const Locale('ar')).sourceCode,
        'sagheerys/vidhoist',
      ),
    ]) {
      final row = find.ancestor(
        of: find.text(vhLtrRun(link)),
        matching: find.byType(ListTile),
      );
      final heading = tester.getRect(
        find.descendant(of: row, matching: find.text(title)),
      );
      final under = tester.getRect(find.text(vhLtrRun(link)));
      expect(under.right, closeTo(heading.right, 1), reason: link);
    }
  });

  testWidgets('each link row has an icon that says what it is', (tester) async {
    await open(tester);
    VhIconData iconOf(String link) => tester
        .widget<VhIcon>(
          find
              .descendant(
                of: find.ancestor(
                  of: find.text(vhLtrRun(link)),
                  matching: find.byType(ListTile),
                ),
                matching: find.byType(VhIcon),
              )
              .first,
        )
        .icon;
    // An envelope stood for X, and a folder for the source code.
    expect(iconOf('x.com/Sagheer700'), VhIcons.at);
    expect(iconOf('github.com/sagheerys'), VhIcons.person);
    expect(iconOf('sagheerys/vidhoist'), VhIcons.code);
  });

  testWidgets("the app's own icon, not a generic symbol", (tester) async {
    await open(tester);

    final image = tester.widget<Image>(find.byType(Image).first);
    // `Image.asset` with `cacheWidth` wraps the provider in a
    // `ResizeImage`.
    final provider = image.image;
    final asset = provider is ResizeImage ? provider.imageProvider : provider;
    expect((asset as AssetImage).assetName, 'assets/icons/icon.png');
  });

  testWidgets('**device matrix**: About does not overflow', (tester) async {
    await expectNoOverflow(tester, host);
  });
}
