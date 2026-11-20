import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart' show ClipRange;
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

/// A stretch's two times against the video's length, once yt-dlp has read
/// it: the length shown, the arrows held at it, a time past it wrong at
/// once rather than failing in yt-dlp with no reason given.
void main() {
  const length = Duration(minutes: 16, seconds: 52);

  Future<(TextEditingController, TextEditingController)> pump(
    WidgetTester tester, {
    Duration? known,
    bool reading = false,
  }) async {
    final from = TextEditingController();
    final to = TextEditingController();
    addTearDown(from.dispose);
    addTearDown(to.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Scaffold(
          body: ClipFields(
            on: true,
            onChanged: (_) {},
            from: from,
            to: to,
            length: known,
            readingLength: reading,
          ),
        ),
      ),
    );
    return (from, to);
  }

  // Seen: 10:00 to 20:00 was accepted for a 16:52 video.
  testWidgets('**the guard**: a time past the video is wrong at once, and '
      'the stretch does not read', (tester) async {
    final (from, to) = await pump(tester, known: length);
    expect(find.text('The video is 16:52 long'), findsOneWidget);
    from.text = '10:00';
    to.text = '20:00';
    await tester.pump();
    expect(find.text('The video ends at 16:52'), findsOneWidget);
    expect(ClipFields.read(from, to, length: length), isNull);

    to.text = '15:00';
    await tester.pump();
    expect(find.text('The video ends at 16:52'), findsNothing);
    expect(
      ClipFields.read(from, to, length: length),
      const ClipRange(Duration(minutes: 10), Duration(minutes: 15)),
    );

    from.text = '17:00';
    await tester.pump();
    expect(find.text('The video ends at 16:52'), findsOneWidget);
  });

  testWidgets('**the guard**: the arrows stop at the video\'s end', (
    tester,
  ) async {
    final (_, to) = await pump(tester, known: length);
    to.text = '16:30';
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump();
    expect(to.text, '16:52');
    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump();
    expect(to.text, '16:52');
  });

  // Held at the end, the number just stopped, saying
  // nothing.
  testWidgets('**the guard**: an arrow pressed at the end shakes the time '
      'and reddens it for a moment', (tester) async {
    final (_, to) = await pump(tester, known: length);
    to.text = '16:52';
    await tester.pump();
    Color? colour() => tester
        .widgetList<EditableText>(find.byType(EditableText))
        .last
        .style
        .color;
    double swing() => tester
        .widgetList<Transform>(
          find.ancestor(
            of: find.byType(EditableText).last,
            matching: find.byType(Transform),
          ),
        )
        .map((t) => t.transform.getTranslation().x.abs())
        .fold(0.0, (a, b) => a > b ? a : b);
    final red = VhThemeX.of(tester.element(find.byType(ClipFields)))
        .palette
        .err;
    expect(colour(), isNot(red));

    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(colour(), red);
    expect(swing(), greaterThan(1));
    expect(to.text, '16:52');

    await tester.pump(const Duration(milliseconds: 600));
    expect(colour(), isNot(red));
    expect(swing(), 0);
  });

  testWidgets('a step inside the video neither shakes nor reddens', (
    tester,
  ) async {
    final (_, to) = await pump(tester, known: length);
    to.text = '10:00';
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump(const Duration(milliseconds: 40));
    final red = VhThemeX.of(tester.element(find.byType(ClipFields)))
        .palette
        .err;
    expect(
      tester
          .widgetList<EditableText>(find.byType(EditableText))
          .last
          .style
          .color,
      isNot(red),
    );
    expect(to.text, '11:00');
  });

  // The end stepped up from nothing read 1:00, and the
  // empty start was then refused at Start.
  testWidgets('**the guard**: the end stepped with no start starts the '
      'stretch at 0:00', (tester) async {
    final (from, to) = await pump(tester, known: length);
    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump();
    expect(from.text, '0:00');
    expect(to.text, '1:00');
    expect(
      ClipFields.read(from, to, length: length),
      const ClipRange(Duration.zero, Duration(minutes: 1)),
    );
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('a start already there stays; a typed end or a stepped start '
      'fills nothing', (tester) async {
    final (from, to) = await pump(tester, known: length);
    from.text = '2:00';
    await tester.tap(find.bySemanticsLabel('A minute later').last);
    await tester.pump();
    expect(from.text, '2:00');
    expect(to.text, '3:00');

    from.text = '';
    to.text = '5:00';
    await tester.pump();
    expect(from.text, '');

    to.text = '';
    await tester.tap(find.bySemanticsLabel('A minute later').first);
    await tester.pump();
    expect(from.text, '1:00');
    expect(to.text, '');
    await tester.pump(const Duration(milliseconds: 600));
  });

  // Before the length came, any time could be typed,
  // and the limit only held from then on.
  group('the length arriving after the times were typed', () {
    Future<
      (TextEditingController, TextEditingController, ValueNotifier<Duration?>)
    >
    arriving(WidgetTester tester) async {
      final from = TextEditingController();
      final to = TextEditingController();
      final known = ValueNotifier<Duration?>(null);
      addTearDown(from.dispose);
      addTearDown(to.dispose);
      addTearDown(known.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: vhTheme(VhVariant.desktop, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Scaffold(
            body: ValueListenableBuilder<Duration?>(
              valueListenable: known,
              builder: (_, length, _) => ClipFields(
                on: true,
                onChanged: (_) {},
                from: from,
                to: to,
                length: length,
                readingLength: length == null,
              ),
            ),
          ),
        ),
      );
      return (from, to, known);
    }

    testWidgets('**the guard**: an end past it comes back to it, shaking '
        'red as at the arrows', (tester) async {
      final (from, to, known) = await arriving(tester);
      from.text = '10:00';
      to.text = '20:00';
      await tester.pump();
      expect(find.text("Reading the video's length…"), findsOneWidget);
      expect(to.text, '20:00');

      known.value = length;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      expect(to.text, '16:52');
      expect(find.text('The video ends at 16:52'), findsNothing);
      final red = VhThemeX.of(tester.element(find.byType(ClipFields)))
          .palette
          .err;
      expect(
        tester
            .widgetList<EditableText>(find.byType(EditableText))
            .last
            .style
            .color,
        red,
      );
      expect(
        ClipFields.read(from, to, length: length),
        const ClipRange(Duration(minutes: 10), length),
      );
      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('a start past it stays, wrong; an end inside it is left '
        'alone', (tester) async {
      final (from, to, known) = await arriving(tester);
      from.text = '17:00';
      to.text = '12:00';
      await tester.pump();
      known.value = length;
      await tester.pumpAndSettle();
      expect(from.text, '17:00');
      expect(to.text, '12:00');
      expect(find.text('The video ends at 16:52'), findsOneWidget);
    });
  });

  testWidgets('a site that gives no length says so', (tester) async {
    final from = TextEditingController();
    final to = TextEditingController();
    addTearDown(from.dispose);
    addTearDown(to.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Scaffold(
          body: ClipFields(
            on: true,
            onChanged: (_) {},
            from: from,
            to: to,
            lengthUnknown: true,
          ),
        ),
      ),
    );
    expect(
      find.text(
        'The site does not say how long the video is, so the times '
        'are not checked',
      ),
      findsOneWidget,
    );
  });

  testWidgets('while the length is read it says so; unknown, nothing is '
      'held back', (tester) async {
    await pump(tester, reading: true);
    expect(find.text("Reading the video's length…"), findsOneWidget);

    final (from, to) = await pump(tester);
    from.text = '10:00';
    to.text = '20:00';
    await tester.pump();
    expect(find.byKey(const ValueKey('clipLength')), findsNothing);
    expect(ClipFields.read(from, to), isNotNull);
  });
}
