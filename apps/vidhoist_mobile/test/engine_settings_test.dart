import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

class _NoSecrets implements SecretStore {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
  @override
  Future<void> delete(String key) async {}
}

/// The engine's own settings: IPv4 by default (`docs/ENGINE.md` findings 7
/// and 20), and subtitles fetched with the download.
void main() {
  test('IPv4 and subtitles are on until turned off, and stay as set', () async {
    final store = MemoryKeyValueStore();
    final fresh = await PhoneSettings.load(store);
    expect(fresh.forceIpv4, isTrue);
    expect(fresh.subtitles, isTrue);

    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(_NoSecrets()),
        initialSettingsProvider.overrideWithValue(fresh),
      ],
    );
    addTearDown(c.dispose);
    await c.read(settingsProvider.notifier).setForceIpv4(false);
    await c.read(settingsProvider.notifier).setSubtitles(false);
    expect(c.read(settingsProvider).forceIpv4, isFalse);

    final again = await PhoneSettings.load(store);
    expect(again.forceIpv4, isFalse);
    expect(again.subtitles, isFalse);
  });

  test('subtitles ask for Arabic and English, or nothing', () {
    expect(
      const PhoneSettings().subtitleLanguages,
      SubtitleLanguages.patterns(['ar', 'en']),
    );
    expect(const PhoneSettings(subtitles: false).subtitleLanguages, isEmpty);
  });

  test('**the guard**: the subtitle languages chosen are the ones asked '
      'for, stay as set, and the last one cannot go', () async {
    final store = MemoryKeyValueStore();
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(_NoSecrets()),
        initialSettingsProvider.overrideWithValue(
          await PhoneSettings.load(store),
        ),
      ],
    );
    addTearDown(c.dispose);
    final notifier = c.read(settingsProvider.notifier);
    await notifier.toggleSubtitleLang('fr');
    await notifier.toggleSubtitleLang('ar');
    await notifier.toggleSubtitleLang('en');
    expect(c.read(settingsProvider).subtitleLangs, ['fr']);
    await notifier.toggleSubtitleLang('fr');
    expect(c.read(settingsProvider).subtitleLangs, ['fr']);
    expect(
      c.read(settingsProvider).subtitleLanguages,
      SubtitleLanguages.patterns(['fr']),
    );
    expect((await PhoneSettings.load(store)).subtitleLangs, ['fr']);
  });

  test('a stored language this build does not offer is dropped, and none '
      'left reads as Arabic and English', () async {
    final store = MemoryKeyValueStore();
    await store.setStringList('download_subtitle_languages', ['xx', 'de']);
    expect((await PhoneSettings.load(store)).subtitleLangs, ['de']);
    await store.setStringList('download_subtitle_languages', ['xx']);
    expect((await PhoneSettings.load(store)).subtitleLangs, ['ar', 'en']);
  });

  test('subtitles go inside the video only when asked and only while they '
      'are fetched at all', () async {
    final store = MemoryKeyValueStore();
    expect((await PhoneSettings.load(store)).tuning.embedSubtitles, isFalse);
    await store.setBool('download_embed_subtitles', true);
    final on = await PhoneSettings.load(store);
    expect(on.tuning.embedSubtitles, isTrue);
    expect(on.copyWith(subtitles: false).tuning.embedSubtitles, isFalse);
  });

  test('**the guard**: the audio format, speed limit and pieces at once '
      'stay as set and reach the engine as one tuning', () async {
    final store = MemoryKeyValueStore();
    final fresh = await PhoneSettings.load(store);
    expect(fresh.tuning.audioFormat, AudioFormat.m4a);
    expect(fresh.tuning.rateLimit, isNull);
    expect(fresh.tuning.concurrentFragments, isNull);

    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(_NoSecrets()),
        initialSettingsProvider.overrideWithValue(fresh),
      ],
    );
    addTearDown(c.dispose);
    final settings = c.read(settingsProvider.notifier);
    await settings.setAudioFormat(AudioFormat.mp3);
    await settings.setRateLimit('2M');
    await settings.setFastStreams(true);

    final again = (await PhoneSettings.load(store)).tuning;
    expect(again.audioFormat, AudioFormat.mp3);
    expect(again.rateLimit, '2M');
    expect(again.concurrentFragments, PhoneSettings.fastPieces);

    await settings.setRateLimit(null);
    expect(c.read(settingsProvider).rateLimit, isNull);
    expect((await PhoneSettings.load(store)).rateLimit, isNull);
  });

  test(
    'a stored value this build does not know reads as the default',
    () async {
      final store = MemoryKeyValueStore();
      await store.setString('audio_format', 'flac');
      await store.setString('download_rate_limit', '3K');
      final read = await PhoneSettings.load(store);
      expect(read.audioFormat, AudioFormat.m4a);
      expect(read.rateLimit, isNull);
    },
  );
}
