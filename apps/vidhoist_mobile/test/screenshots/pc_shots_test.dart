@Tags(['shots'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_screen.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

import '../pc_link_test.dart' show FakeApi;
import 'shot_kit.dart';

/// **The computer's page on the phone, for the project's pages**: a phone
/// paired with an invented computer, its library with the sample covers and
/// one download running there. As `phone_shots_test.dart`, run only with
/// `VH_SHOTS=1`.
void main() {
  setUpAll(loadShotFonts);

  const pairing = PcPairing(
    host: '192.168.1.24',
    port: PcLink.defaultPort,
    fingerprint:
        '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
    deviceId: 'dev1',
    secret: 'the-secret',
    name: 'HOME-PC',
  );

  for (final lang in ['ar', 'en']) {
    for (final brightness in Brightness.values) {
      final arabic = lang == 'ar';
      final tag = '$lang-${brightness == Brightness.dark ? 'night' : 'day'}';

      testWidgets('pc $tag', skip: !shotsEnabled, (tester) async {
        useShotDevice(tester);
        final secrets = MemorySecretStore();
        await secrets.write(pcSecretKey, pairing.secret);
        final clips = arabic ? shotArabicClips : shotEnglishClips;
        final api = _ShotApi()
          ..live = [
            PcTask(
              id: 't1',
              url: 'https://vimeo.com/900010',
              title: clips[5].$1,
              phase: 'downloading',
              progress: 64,
              speed: 8.4e6,
              eta: 95,
            ),
          ]
          ..catalog = [
            for (final (i, (title, cover, minutes, audio)) in clips.indexed)
              // Named for this shot: the page keeps covers by name for the
              // whole run, and one kept from another shot never showed.
              PcItem(
                id: '$cover@$tag',
                title: title,
                uploader: (arabic
                    ? shotArabicChannels
                    : shotEnglishChannels)[i % 3],
                hasCover: true,
                duration: Duration(minutes: minutes, seconds: 7 + i * 6),
                sizeBytes: (minutes * 9.5 * 1000000).round(),
                added: DateTime.now().subtract(Duration(hours: 3 + i * 9)),
                isAudio: audio,
              ),
          ];
        final router = GoRouter(
          initialLocation: '/pc',
          routes: [
            GoRoute(
              path: '/pc',
              builder: (context, _) => VhAdaptiveScaffold(
                items: shellNavItems(context.vhl, shellTabs(paired: true)),
                selectedIndex: 2,
                onSelected: (_) {},
                body: const PcScreen(),
              ),
            ),
          ],
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
              secretStoreProvider.overrideWithValue(secrets),
              prefsMutexProvider.overrideWithValue(PrefsMutex()),
              initialSettingsProvider.overrideWithValue(const PhoneSettings()),
              loggerProvider.overrideWithValue(
                VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc.log'),
              ),
              initialPcPairingProvider.overrideWithValue(pairing),
              pcClientProvider.overrideWith((ref) => api),
              pcFinderProvider.overrideWithValue((_) async => null),
              downloadEngineProvider.overrideWithValue(null),
            ],
            child: RepaintBoundary(
              key: shotKey,
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                locale: Locale(lang),
                localizationsDelegates: VhLocalizations.localizationsDelegates,
                supportedLocales: VhLocalizations.supportedLocales,
                theme: shotTheme(Locale(lang), brightness),
              ),
            ),
          ),
        );
        // The page asks again every couple of seconds while something
        // downloads, so it never settles.
        await settleShot(tester, still: false);
        await saveShot(tester, 'phone-pc-$tag');
      });
    }
  }
}

/// The invented computer, its covers read from the sample covers by name.
class _ShotApi extends FakeApi {
  @override
  Future<Uint8List?> cover(String id) async {
    // Read at once: a read the test's clock holds back never lands.
    final file = File('$shotCovers/${id.split('@').first}.jpg');
    return file.existsSync() ? file.readAsBytesSync() : null;
  }
}
