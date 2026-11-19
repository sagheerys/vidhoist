import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/audio/audio_screen.dart';
import 'package:vidhoist_mobile/features/audio/audio_transcript.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/player/sidecar_subtitles.dart';
import 'package:vidhoist_mobile/features/player/transcript_pane.dart';

import 'device_matrix.dart';
import 'fake_audio_port.dart';

/// The music player showing what is said in the clip it plays (asked
/// 2026-11-19: a clip downloaded as sound was found by the search, but its
/// words showed nowhere once it played).
void main() {
  const song = PlaylistItem(
    canonicalUrl: 'https://example.com/song',
    title: 'A long talk',
    localPath: '/media/song.m4a',
    isAudio: true,
  );
  const silent = PlaylistItem(
    canonicalUrl: 'https://example.com/silent',
    title: 'Only music',
    localPath: '/media/silent.m4a',
    isAudio: true,
  );
  final english = [
    const VhCaptionLine(
      start: Duration(seconds: 5),
      end: Duration(seconds: 9),
      text: 'welcome to the workshop',
    ),
    const VhCaptionLine(
      start: Duration(seconds: 70),
      end: Duration(seconds: 74),
      text: 'the backup is restored from the second disk',
    ),
    const VhCaptionLine(
      start: Duration(seconds: 120),
      end: Duration(seconds: 124),
      text: 'and the backup runs every night',
    ),
  ];
  final arabic = [
    const VhCaptionLine(
      start: Duration(seconds: 5),
      end: Duration(seconds: 9),
      text: 'أهلاً بكم في الورشة',
    ),
  ];

  late FakeAudioPort port;
  late VhAudioHandler handler;

  setUp(() {
    port = FakeAudioPort();
    handler = fakeAudioHandler(port);
  });
  tearDown(() => handler.dispose());

  ProviderContainer scope({
    Map<String, List<VhCaptionLine>> songTracks = const {},
  }) {
    final container = ProviderContainer(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
        localMediaProvider.overrideWith((ref) async => const []),
        subtitleCacheProvider.overrideWith(
          () => _Read({
            song.localPath!: {'en': english, ...songTracks},
            silent.localPath!: const {},
          }),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Widget app(
    ProviderContainer container, {
    Locale locale = const Locale('en'),
  }) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      theme: vhTheme(VhVariant.phone, Brightness.light),
      home: const AudioScreen(),
    ),
  );

  Future<void> play(WidgetTester tester, PlaylistItem item) async {
    await tester.runAsync(() async {
      await handler.playItems([item, silent], startIndex: 0);
      await handler.pause();
    });
  }

  Future<void> show(
    WidgetTester tester,
    ProviderContainer container, {
    Size size = const Size(384, 823),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(container));
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: on a tall phone the line being said shows '
      'under the controls, and moves with the time', (tester) async {
    await play(tester, song);
    await show(tester, scope());

    expect(find.byType(TranscriptPeek), findsOneWidget);
    expect(find.text('welcome to the workshop'), findsOneWidget);

    port.emit(const Duration(seconds: 71));
    await tester.pumpAndSettle();
    expect(
      find.text('the backup is restored from the second disk'),
      findsOneWidget,
    );
    expect(find.text('and the backup runs every night'), findsOneWidget);
    expect(find.text('welcome to the workshop'), findsNothing);
  });

  testWidgets('**the guard**: on a short phone a transcript button opens '
      'the whole text, and a tap on a line plays from there', (tester) async {
    await play(tester, song);
    await show(tester, scope(), size: const Size(360, 640));
    expect(find.byType(TranscriptPeek), findsNothing);

    await tester.tap(find.byTooltip('Transcript'));
    await tester.pumpAndSettle();
    expect(find.byType(TranscriptPane), findsOneWidget);

    await tester.tap(find.text('and the backup runs every night'));
    await tester.pumpAndSettle();
    expect(port.calls.last, 'seek(${const Duration(seconds: 120)})');
  });

  testWidgets('the sheet closes when the queue moves on, rather than show '
      'the last clip\'s words', (tester) async {
    await play(tester, song);
    await show(tester, scope(), size: const Size(360, 640));
    await tester.tap(find.byTooltip('Transcript'));
    await tester.pumpAndSettle();
    expect(find.byType(TranscriptPane), findsOneWidget);

    await tester.runAsync(() async {
      await handler.skipToNext();
      await handler.pause();
    });
    await tester.pumpAndSettle();
    expect(find.byType(TranscriptPane), findsNothing);
  });

  testWidgets('a clip with no subtitles shows neither the line nor the '
      'button', (tester) async {
    await play(tester, silent);
    await show(tester, scope());
    expect(find.byType(TranscriptPeek), findsNothing);
    expect(find.byTooltip('Transcript'), findsNothing);
  });

  testWidgets('two languages: the name in the peek moves to the next, and '
      'the video\'s subtitles follow the same choice', (tester) async {
    await play(tester, song);
    final container = scope(songTracks: {'ar': arabic});
    await show(tester, container);
    expect(find.text('welcome to the workshop'), findsOneWidget);

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(find.text('أهلاً بكم في الورشة'), findsOneWidget);
    expect(container.read(subtitleChoiceProvider).language.value, 'ar');
  });

  testWidgets('**device matrix**: the music player with its transcript '
      'never overflows', (tester) async {
    await play(tester, song);
    final container = scope(songTracks: {'ar': arabic});
    for (final locale in const [Locale('ar'), Locale('en')]) {
      await expectNoOverflow(tester, () => app(container, locale: locale));
    }
  });
}

/// The subtitles already read, so no file is asked for.
class _Read extends SubtitleCache {
  _Read(this.read);

  final Map<String, Map<String, List<VhCaptionLine>>> read;

  @override
  Map<String, Map<String, List<VhCaptionLine>>> build() => read;
}
