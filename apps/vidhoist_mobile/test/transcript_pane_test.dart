import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/player/transcript_pane.dart';

import 'device_matrix.dart';

/// **The transcript on the phone** (batch 6b): the subtitles line by line,
/// the one being said lit and followed, a search that folds Arabic, and a
/// tap that plays from a line.
void main() {
  VhCaptionLine line(int second, String text) => VhCaptionLine(
    start: Duration(seconds: second),
    end: Duration(seconds: second + 2),
    text: text,
  );

  final arabic = [
    line(0, 'مرحباً بكم'),
    line(2, 'نتحدث اليوم عن الإسلام والتاريخ'),
    line(4, 'ثم عن أهل العلم'),
    line(6, 'وفي الختام شكراً'),
  ];
  final english = [line(0, 'Welcome'), line(2, 'Today, history')];

  late ValueNotifier<Duration> position;
  late ValueNotifier<String?> language;
  late List<Duration> seeks;

  setUp(() {
    position = ValueNotifier(Duration.zero);
    language = ValueNotifier(null);
    seeks = [];
  });

  Widget app({
    Map<String, List<VhCaptionLine>>? tracks,
    String lang = 'ar',
    Brightness brightness = Brightness.light,
  }) => MaterialApp(
    theme: vhTheme(VhVariant.desktop, brightness),
    locale: Locale(lang),
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    home: Scaffold(
      body: TranscriptPane(
        tracks: tracks ?? {'ar': arabic},
        language: language,
        position: position,
        onSeek: seeks.add,
      ),
    ),
  );

  String? lit(WidgetTester tester) => tester
      .widgetList<TranscriptLineTile>(find.byType(TranscriptLineTile))
      .where((t) => t.current)
      .map((t) => t.text)
      .singleOrNull;

  testWidgets('every line, the one being said lit, and it follows', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    expect(find.byType(TranscriptLineTile), findsNWidgets(4));
    expect(lit(tester), 'مرحباً بكم');
    position.value = const Duration(seconds: 4, milliseconds: 500);
    await tester.pumpAndSettle();
    expect(lit(tester), 'ثم عن أهل العلم');
  });

  testWidgets('a tap on a line plays from its start', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('وفي الختام شكراً'));
    await tester.pumpAndSettle();
    expect(seeks, [const Duration(seconds: 6)]);
  });

  testWidgets('**the guard**: a word typed without hamza finds it written '
      'with one', (tester) async {
    await tester.pumpWidget(app());
    await tester.enterText(find.byType(TextField), 'الاسلام');
    await tester.pumpAndSettle();
    expect(find.text('1 من 1'), findsOne);
    final hits = tester
        .widgetList<TranscriptLineTile>(find.byType(TranscriptLineTile))
        .where((t) => t.marks.isNotEmpty)
        .map((t) => t.text);
    expect(hits, ['نتحدث اليوم عن الإسلام والتاريخ']);
  });

  testWidgets('steps between the results, and says when there are none', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.enterText(find.byType(TextField), 'عن');
    await tester.pumpAndSettle();
    expect(find.text('1 من 2'), findsOne);
    await tester.tap(find.byTooltip('النتيجة التالية'));
    await tester.pumpAndSettle();
    expect(find.text('2 من 2'), findsOne);
    await tester.tap(find.byTooltip('النتيجة التالية'));
    await tester.pumpAndSettle();
    expect(find.text('1 من 2'), findsOne);
    await tester.tap(find.byTooltip('النتيجة السابقة'));
    await tester.pumpAndSettle();
    expect(find.text('2 من 2'), findsOne);

    await tester.enterText(find.byType(TextField), 'غائب');
    await tester.pumpAndSettle();
    expect(find.text('لا نتائج'), findsOne);
  });

  testWidgets('two languages: a switch between them, kept for the player', (
    tester,
  ) async {
    await tester.pumpWidget(app(tracks: {'ar': arabic, 'en': english}));
    expect(find.text('مرحباً بكم'), findsOne);
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(language.value, 'en');
    expect(find.text('Welcome'), findsOne);
    expect(find.text('مرحباً بكم'), findsNothing);
  });

  testWidgets('one language: no switch', (tester) async {
    await tester.pumpWidget(app());
    expect(find.text('AR'), findsNothing);
  });

  testWidgets('fits every phone and tablet, at every text size, both '
      'languages and both themes', (tester) async {
    for (final lang in ['ar', 'en']) {
      for (final brightness in Brightness.values) {
        await expectNoOverflow(
          tester,
          () => app(
            tracks: {'ar': arabic, 'en': english},
            lang: lang,
            brightness: brightness,
          ),
        );
      }
    }
  });
}
