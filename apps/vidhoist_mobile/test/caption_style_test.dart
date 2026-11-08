import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/player/caption_style.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/settings/widgets/settings_fields.dart';

import 'device_matrix.dart';

/// **The subtitles' size and background on the phone** (batch 6b): four
/// sizes and three backgrounds, in the playback settings and under a long
/// press on CC, kept between runs.
void main() {
  Future<ProviderContainer> containerWith(
    WidgetTester tester,
    MemoryKeyValueStore store,
  ) async {
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(
          await tester.runAsync(() => PhoneSettings.load(store)) ??
              const PhoneSettings(),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Widget app(ProviderContainer container, Widget child, {String lang = 'en'}) =>
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: vhTheme(VhVariant.desktop, Brightness.light),
          locale: Locale(lang),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      );

  test('medium over a dark capsule until chosen otherwise', () {
    const settings = PhoneSettings();
    expect(settings.captionScale, 1.0);
    expect(settings.captionBackdrop, VhCaptionBackground.solid);
    expect(PhoneSettings.captionScales, hasLength(4));
    // Each size larger than the one before it.
    for (var i = 1; i < PhoneSettings.captionScales.length; i++) {
      expect(
        PhoneSettings.captionScales[i],
        greaterThan(PhoneSettings.captionScales[i - 1]),
      );
    }
  });

  test('a stored choice out of range falls back inside it', () {
    const settings = PhoneSettings(captionSize: 9, captionBackground: -3);
    expect(settings.captionScale, PhoneSettings.captionScales.last);
    expect(settings.captionBackdrop, VhCaptionBackground.solid);
  });

  testWidgets('**the guard**: the playback settings choose and keep them', (
    tester,
  ) async {
    final store = MemoryKeyValueStore();
    final container = await containerWith(tester, store);
    await tester.pumpWidget(app(container, const PlaybackFields()));

    await tester.tap(find.text('Larger'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();

    final settings = container.read(settingsProvider);
    expect(settings.captionSize, 3);
    expect(settings.captionBackdrop, VhCaptionBackground.none);
    expect(await store.getInt('caption_size'), 3);
    expect(await store.getInt('caption_background'), 2);

    final reloaded = await tester.runAsync(() => PhoneSettings.load(store));
    expect(reloaded!.captionSize, 3);
    expect(reloaded.captionBackground, 2);
  });

  testWidgets('the player says where else they are', (tester) async {
    final container = await containerWith(tester, MemoryKeyValueStore());
    await tester.pumpWidget(app(container, const PlaybackFields()));
    expect(find.text('Also in the player: hold the CC button.'), findsOne);
  });

  testWidgets('the options sheet: size, background, language, transcript', (
    tester,
  ) async {
    final container = await containerWith(tester, MemoryKeyValueStore());
    final language = ValueNotifier<String?>(null);
    var transcript = 0;
    const ar = [
      VhCaptionLine(
        start: Duration.zero,
        end: Duration(seconds: 2),
        text: 'مرحبا',
      ),
    ];
    const en = [
      VhCaptionLine(
        start: Duration.zero,
        end: Duration(seconds: 2),
        text: 'hello',
      ),
    ];
    final captions = VhCaptions(
      lines: ar,
      tracks: const {'ar': ar, 'en': en},
      language: language,
      shown: ValueNotifier(true),
    );
    await tester.pumpWidget(
      app(
        container,
        CaptionOptions(captions: captions, onTranscript: () => transcript++),
      ),
    );
    expect(find.text('Larger'), findsOne);
    expect(find.text('Light'), findsOne);
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(language.value, 'en');
    await tester.tap(find.text('Read the transcript'));
    await tester.pumpAndSettle();
    expect(transcript, 1);
  });

  testWidgets('one language: no language choice', (tester) async {
    final container = await containerWith(tester, MemoryKeyValueStore());
    const en = [
      VhCaptionLine(
        start: Duration.zero,
        end: Duration(seconds: 2),
        text: 'hello',
      ),
    ];
    await tester.pumpWidget(
      app(
        container,
        CaptionOptions(
          captions: VhCaptions(lines: en, shown: ValueNotifier(true)),
          onTranscript: () {},
        ),
      ),
    );
    expect(find.text('EN'), findsNothing);
    expect(find.text('Subtitle language'), findsNothing);
  });

  testWidgets('fits every phone and tablet, at every text size, both '
      'languages', (tester) async {
    final container = await containerWith(tester, MemoryKeyValueStore());
    const en = [
      VhCaptionLine(
        start: Duration.zero,
        end: Duration(seconds: 2),
        text: 'hello',
      ),
    ];
    final captions = VhCaptions(
      lines: en,
      tracks: const {'en': en, 'ar': en},
      language: ValueNotifier(null),
      shown: ValueNotifier(true),
    );
    for (final lang in ['en', 'ar']) {
      await expectNoOverflow(
        tester,
        () => app(
          container,
          Column(
            children: [
              const PlaybackFields(),
              CaptionOptions(captions: captions, onTranscript: () {}),
            ],
          ),
          lang: lang,
        ),
      );
    }
  });
}
