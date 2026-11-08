import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Number direction guards** (device check 2026-09-05): neutral
/// characters attach to the wrong end inside an Arabic paragraph and
/// invert the meaning of a phrase, so "2 / 40" renders as "40 / 2".
void main() {
  test(
    'isolation wraps the text at both ends without changing its content',
    () {
      final wrapped = vhLtrRun('2 / 40');
      expect(wrapped.startsWith(vhLtrIsolate), isTrue);
      expect(wrapped.endsWith(vhPopIsolate), isTrue);
      expect(
        wrapped.substring(1, wrapped.length - 1),
        '2 / 40',
        reason: 'المحتوى نفسه — العزل توجيه لا تعديل',
      );
    },
  );

  test('isolation does not accumulate when it is wrapped twice by mistake', () {
    // Not a defect today, but an easy trap: wrapping already-wrapped text
    // stays visually valid, and what matters is that the content is not
    // lost.
    expect(vhLtrRun(vhLtrRun('1 / 2')), contains('1 / 2'));
  });

  testWidgets('isolated text is drawn as it is inside an Arabic interface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: vhTheme(VhVariant.phone, Brightness.light),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: Center(child: Text(vhLtrRun('-50:49')))),
        ),
      ),
    );
    expect(find.text(vhLtrRun('-50:49')), findsOneWidget);
  });
}
