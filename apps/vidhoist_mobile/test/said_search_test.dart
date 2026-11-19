import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/media_access.dart';
import 'package:vidhoist_mobile/features/player/playback_providers.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/transcripts/said_index.dart';
import 'package:vidhoist_mobile/features/transcripts/said_moment.dart';
import 'package:vidhoist_mobile/features/transcripts/said_results.dart';

import 'device_matrix.dart';
import 'fake_audio_port.dart';

/// The library's search finding what was **said** in a clip, from the
/// subtitle files its download wrote (asked 2026-11-19: the phone showed a
/// clip's transcript under the player and could not search it).
void main() {
  const vtt = '''
WEBVTT

00:00:05.000 --> 00:00:09.000
welcome to the workshop

00:01:10.000 --> 00:01:14.000
the backup is restored from the second disk

00:02:00.000 --> 00:02:04.000
and the backup runs every night
''';

  LocalItem item(String name, {String? path, String? title}) => LocalItem(
    key: 'https://example.com/$name',
    canonicalUrl: 'https://example.com/$name',
    path: path ?? '/media/$name.mp4',
    title: title ?? name,
    sizeBytes: 1,
    modified: DateTime(2026, 11, 19),
  );

  Transcript words(
    String url,
    List<(int, String)> lines, {
    String lang = 'en',
  }) => Transcript(
    canonicalUrl: url,
    language: lang,
    source: 'captions',
    fetchedAt: DateTime(2026, 11, 19),
    segments: [
      for (final (at, text) in lines)
        TranscriptSegment(
          start: Duration(seconds: at),
          end: Duration(seconds: at + 4),
          text: text,
        ),
    ],
  );

  group('reading the subtitle files beside the clips', () {
    late Directory root;
    late ProviderContainer container;

    setUp(() {
      root = Directory.systemTemp.createTempSync('said_');
      Directory('${root.path}/media').createSync();
      container = ProviderContainer(
        overrides: [
          saidStoreProvider.overrideWith(
            (ref) async => TranscriptStore(Directory('${root.path}/store')),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      root.deleteSync(recursive: true);
    });

    LocalItem onDisk(
      String name, {
      Map<String, String> subtitles = const {},
      String extension = 'mp4',
    }) {
      final path = '${root.path}/media/$name.$extension';
      File(path).writeAsStringSync('');
      for (final MapEntry(key: language, value: text) in subtitles.entries) {
        File('${root.path}/media/$name.$language.vtt').writeAsStringSync(text);
      }
      return item(name, path: path);
    }

    test('**the guard**: a clip with subtitles is found by a word said in '
        'it, at the second it was said', () async {
      final talk = onDisk('talk', subtitles: {'en': vtt});
      final silent = onDisk('silent');
      await container.read(saidIndexerProvider).run([talk, silent]);

      final index = await container.read(saidIndexProvider.future);
      final found = index.search('backup');
      expect(found.single.canonicalUrl, talk.key);
      expect(found.single.hits.first.start, const Duration(seconds: 70));
      expect(found.single.total, 2);
      expect(index.contains(silent.key), isFalse);
      expect(container.read(saidRevisionProvider), 1);
    });

    test('a clip downloaded as sound is searched like a video: its '
        'subtitles sit beside the audio file the same way', () async {
      final song = onDisk('song', subtitles: {'en': vtt}, extension: 'm4a');
      expect(song.isAudio, isTrue);
      await container.read(saidIndexerProvider).run([song]);

      final index = await container.read(saidIndexProvider.future);
      expect(index.search('workshop').single.canonicalUrl, song.key);
    });

    test('a clip is read once: its words outlive its subtitle file, and a '
        'second walk changes nothing', () async {
      final talk = onDisk('talk', subtitles: {'en': vtt});
      final indexer = container.read(saidIndexerProvider);
      await indexer.run([talk]);
      File('${root.path}/media/talk.en.vtt').deleteSync();
      await indexer.run([talk]);

      final index = await container.read(saidIndexProvider.future);
      expect(index.search('workshop'), hasLength(1));
      expect(container.read(saidRevisionProvider), 1);
    });

    test(
      'what was read is there at the next launch, without the files',
      () async {
        final talk = onDisk('talk', subtitles: {'en': vtt});
        await container.read(saidIndexerProvider).run([talk]);

        final next = ProviderContainer(
          overrides: [
            saidStoreProvider.overrideWith(
              (ref) async => TranscriptStore(Directory('${root.path}/store')),
            ),
          ],
        );
        addTearDown(next.dispose);
        final index = await next.read(saidIndexProvider.future);
        expect(index.search('second disk'), hasLength(1));
      },
    );

    test('**the guard**: a clip that left the library takes its words '
        'with it', () async {
      final talk = onDisk('talk', subtitles: {'en': vtt});
      final other = onDisk('other', subtitles: {'en': vtt});
      final indexer = container.read(saidIndexerProvider);
      await indexer.run([talk, other]);
      await indexer.run([other]);

      final index = await container.read(saidIndexProvider.future);
      expect(index.urls, [other.key]);
      final store = await container.read(saidStoreProvider.future);
      expect(await store.has(talk.key), isFalse);
      expect(await store.has(other.key), isTrue);
    });

    test('two languages are both searched; `ar-orig` beside `ar` is one '
        'language, and another clip\'s files are not taken', () async {
      const arabic = '''
WEBVTT

00:00:03.000 --> 00:00:07.000
أهلاً بكم في الورشة
''';
      final talk = onDisk(
        'talk',
        subtitles: {'en': vtt, 'ar': arabic, 'ar-orig': arabic},
      );
      // A longer name that starts the same is another clip.
      final sequel = onDisk('talk two');
      await container.read(saidIndexerProvider).run([talk, sequel]);

      final index = await container.read(saidIndexProvider.future);
      expect(index.search('الورشه').single.canonicalUrl, talk.key);
      expect(index.search('workshop').single.canonicalUrl, talk.key);
      expect(
        index.transcriptsFor(talk.key).map((t) => t.language),
        unorderedEquals(['en', 'ar']),
      );
      expect(index.contains(sequel.key), isFalse);
    });

    test('a folder that cannot be read leaves the search as it was', () async {
      final gone = item('gone', path: '${root.path}/nowhere/gone.mp4');
      await container.read(saidIndexerProvider).run([gone]);
      final index = await container.read(saidIndexProvider.future);
      expect(index.length, 0);
    });
  });

  group('in the library', () {
    final talk = item(
      'talk',
      title:
          'Homelab Hour — Ep. 12: Backups that actually restore, and the '
          'ones that do not',
    );
    final lecture = item('lecture', title: 'محاضرة عن النسخ الاحتياطي');
    final index = TranscriptIndex()
      ..add(
        words(talk.key, [
          (5, 'welcome to the workshop'),
          (70, 'the backup is restored from the second disk'),
          (120, 'and the backup runs every night'),
          (300, 'a backup nobody tested is not a backup'),
          (400, 'so test the backup'),
        ]),
      )
      ..add(
        words(lecture.key, [
          (15, 'النسخة الاحتياطية تُحفظ على قرص ثانٍ في مكان آخر'),
        ], lang: 'ar'),
      )
      // Words of a clip the library no longer has.
      ..add(words('https://example.com/gone', [(1, 'the backup is gone')]));

    Future<ProviderContainer> library(String query) async {
      final container = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          secretStoreProvider.overrideWithValue(MemorySecretStore()),
          prefsMutexProvider.overrideWithValue(PrefsMutex()),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          mediaAccessGateProvider.overrideWithValue(
            MediaAccessGate(
              probe: () async => true,
              isGranted: (_) async => true,
              ask: (_) async => true,
            ),
          ),
          localMediaProvider.overrideWith((ref) async => [talk, lecture]),
          saidIndexProvider.overrideWith((ref) async => index),
        ],
      );
      addTearDown(container.dispose);
      await container.read(localMediaProvider.future);
      await container.read(saidIndexProvider.future);
      container.read(libraryViewProvider.notifier).setQuery(query);
      return container;
    }

    Widget screen(ProviderContainer container, Locale locale) =>
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: locale,
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            theme: vhTheme(VhVariant.phone, Brightness.light),
            home: const LibraryScreen(),
          ),
        );

    test('the clips a word was said in, three moments each, and never one '
        'the library no longer has', () async {
      final container = await library('backup');
      final results = container.read(saidResultsProvider);
      expect(results.single.$1.key, talk.key);
      expect(results.single.$2.hits, hasLength(3));
      expect(results.single.$2.total, greaterThan(3));

      container.read(libraryViewProvider.notifier).setQuery('');
      expect(container.read(saidResultsProvider), isEmpty);
    });

    testWidgets('**the guard**: a word no title holds still finds the clip '
        'it was said in, under "Said inside clips", not "No results"', (
      tester,
    ) async {
      final container = await tester.runAsync(() => library('workshop'));
      await tester.pumpWidget(screen(container!, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Said inside clips'), findsOneWidget);
      expect(find.text('No results'), findsNothing);
      expect(find.textContaining('Homelab Hour'), findsOneWidget);
      expect(find.byType(SaidMomentRow), findsOneWidget);
      // The time carries a direction mark so it reads the same in Arabic.
      expect(find.textContaining('0:05'), findsOneWidget);
    });

    testWidgets('a word said nowhere and in no title is "No results"', (
      tester,
    ) async {
      final container = await tester.runAsync(() => library('zebra'));
      await tester.pumpWidget(screen(container!, const Locale('en')));
      await tester.pumpAndSettle();
      expect(find.text('No results'), findsOneWidget);
      expect(find.text('Said inside clips'), findsNothing);
    });

    testWidgets('Arabic typed without its marks finds it as written, and '
        'the moments beyond three are counted', (tester) async {
      // Tall enough for the whole list: a sliver builds only what shows.
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(600, 2400);
      addTearDown(tester.view.reset);
      final arabic = await tester.runAsync(() => library('النسخه الاحتياطيه'));
      await tester.pumpWidget(screen(arabic!, const Locale('ar')));
      await tester.pumpAndSettle();
      expect(find.text('قيل داخل المقاطع'), findsOneWidget);
      expect(find.byType(SaidMomentRow), findsOneWidget);

      final english = await tester.runAsync(() => library('backup'));
      await tester.pumpWidget(screen(english!, const Locale('en')));
      await tester.pumpAndSettle();
      expect(find.byType(SaidMomentRow), findsNWidgets(3));
      expect(find.text('Said once more'), findsOneWidget);
    });

    testWidgets('**the guard**: a tap on a moment plays the clip from that '
        'second', (tester) async {
      final container = await tester.runAsync(() => library('second disk'));
      await tester.pumpWidget(screen(container!, const Locale('en')));
      await tester.pumpAndSettle();

      // The route is not in this app of one screen; what the tap asked for
      // is what the player reads when it opens.
      await tester.runAsync(
        () => playFromMoment(
          tester.element(find.byType(SaidMomentRow)),
          container.read,
          talk,
          const Duration(seconds: 70),
        ).catchError((Object _) {}),
      );
      final request = container.read(playbackRequestProvider);
      expect(request!.items.single.canonicalUrl, talk.key);
      expect(
        await tester.runAsync(
          () => container.read(playbackPositionsProvider).positionOf(talk.key),
        ),
        const Duration(seconds: 70),
      );
    });

    testWidgets('**the guard**: a moment of a clip downloaded as sound '
        'plays it in the music player from that second', (tester) async {
      final port = FakeAudioPort();
      final handler = fakeAudioHandler(port);
      final song = item('song', path: '/media/song.m4a');
      final container = ProviderContainer(
        overrides: [audioHandlerProvider.overrideWithValue(handler)],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SizedBox()),
        ),
      );

      await tester.runAsync(
        () => playFromMoment(
          tester.element(find.byType(SizedBox)),
          container.read,
          song,
          const Duration(seconds: 70),
        ),
      );
      expect(handler.currentItem!.canonicalUrl, song.key);
      expect(port.calls.last, 'seek(${const Duration(seconds: 70)})');
      // Its timers were started inside this test, so they stop inside it.
      await tester.runAsync(handler.dispose);
    });

    testWidgets('**device matrix**: the results never overflow', (
      tester,
    ) async {
      for (final (locale, query) in const [
        (Locale('en'), 'backup'),
        (Locale('ar'), 'النسخة'),
      ]) {
        final container = await tester.runAsync(() => library(query));
        await expectNoOverflow(tester, () => screen(container!, locale));
      }
    });
  });
}
