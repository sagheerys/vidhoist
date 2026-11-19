import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **The guard**: a phone seen a moment ago read "0 seconds ago", in
/// Arabic, on the computer.
void main() {
  setUpAll(initVhL10n);

  Future<String> ago(WidgetTester tester, Locale locale, Duration age) async {
    final now = DateTime(2026, 11, 10, 12);
    late String said;
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            said = vhTimeAgo(context, now.subtract(age), now: now);
            return const SizedBox();
          },
        ),
      ),
    );
    return said;
  }

  testWidgets('**the guard**: under a minute is "just now", not seconds', (
    tester,
  ) async {
    expect(await ago(tester, const Locale('ar'), Duration.zero), 'الآن');
    expect(
      await ago(tester, const Locale('ar'), const Duration(seconds: 40)),
      'الآن',
    );
    expect(await ago(tester, const Locale('en'), Duration.zero), 'just now');
  });

  testWidgets('a minute and more still counts', (tester) async {
    expect(
      await ago(tester, const Locale('ar'), const Duration(minutes: 5)),
      contains('5'),
    );
    expect(
      await ago(tester, const Locale('en'), const Duration(hours: 2)),
      contains('2 hours'),
    );
  });
}
