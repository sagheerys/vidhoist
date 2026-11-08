import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// A channel's subscribers, as a phone row has room for.
void main() {
  for (final (lang, n, shown) in [
    ('en', 1234567, '1.23M'),
    ('en', 950, '950'),
    // Intl joins the number to its word with a no-break space.
    ('ar', 1234567, '1.23\u00a0مليون'),
  ]) {
    testWidgets('$n in $lang reads $shown', (tester) async {
      late String got;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(lang),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              got = vhCompactCount(context, n);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(got, shown);
    });
  }
}
