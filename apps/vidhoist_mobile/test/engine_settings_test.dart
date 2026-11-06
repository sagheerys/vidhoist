import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
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
    final fresh = await LiteSettings.load(store);
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

    final again = await LiteSettings.load(store);
    expect(again.forceIpv4, isFalse);
    expect(again.subtitles, isFalse);
  });

  test('subtitles ask for Arabic and English, or nothing', () {
    expect(
      const LiteSettings().subtitleLanguages,
      SubtitleLanguages.patterns(['ar', 'en']),
    );
    expect(const LiteSettings(subtitles: false).subtitleLanguages, isEmpty);
  });
}
