@Tags(['shots'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/background/background_state.dart';
import 'package:vidhoist_mobile/features/background/background_status.dart';
import 'package:vidhoist_mobile/features/channels/channel_art.dart';
import 'package:vidhoist_mobile/features/channels/channels_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/media_access.dart';
import 'package:vidhoist_mobile/features/player/playback_providers.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/language_screen.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

import '../fake_audio_port.dart';
import 'shot_kit.dart';

/// **The phone's screenshots for the project's pages**, made from the app's
/// own widgets with its own fonts and covers drawn for the purpose
/// (`tool/screenshots/make_covers.py`), so they show nobody's clips.
///
/// Not part of the test run: `VH_SHOTS=1 flutter test test/screenshots`
/// writes them to `docs/screenshots/`.
void main() {
  setUpAll(loadShotFonts);

  Widget framed(
    ProviderContainer c,
    Locale locale,
    Brightness brightness,
    Widget home,
  ) => UncontrolledProviderScope(
    container: c,
    child: RepaintBoundary(
      key: shotKey,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: shotTheme(locale, brightness),
        home: home,
      ),
    ),
  );

  ProviderContainer container(List<Override> more, {KeyValueStore? store}) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store ?? MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        ...more,
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// The library in the app's own frame: its bar, its add button.
  Future<ProviderContainer> library(bool arabic) async {
    final store = MemoryKeyValueStore();
    await store.setString('library_view_mode', LibraryViewMode.grid.name);
    return container(store: store, [
      mediaAccessGateProvider.overrideWithValue(
        MediaAccessGate(
          probe: () async => true,
          isGranted: (_) async => true,
          ask: (_) async => true,
        ),
      ),
      localMediaProvider.overrideWith((ref) async => shotLibrary(arabic)),
    ]);
  }

  /// [playing] puts the "now playing" panel beside it, where there is room.
  Widget libraryFrame({VhAudioHandler? playing}) => Consumer(
    builder: (context, ref, _) => VhAdaptiveScaffold(
      items: shellNavItems(context.vhl, shellTabs(paired: false)),
      selectedIndex: 0,
      onSelected: (_) {},
      body: const LibraryScreen(),
      endPane: playing == null
          ? null
          : VhNowPlayingPanel(
              handler: playing,
              artwork: artworkBuilderFor(ref),
              cover: coverBuilderFor(ref),
              showSourceChip: false,
              onOpen: () {},
              onCollapse: () {},
            ),
      floatingActionButton: VhFab(
        label: context.vhl.addLinkFab,
        onPressed: () {},
      ),
    ),
  );

  for (final lang in ['ar', 'en']) {
    for (final brightness in Brightness.values) {
      final arabic = lang == 'ar';
      final tag = '$lang-${brightness == Brightness.dark ? 'night' : 'day'}';

      testWidgets('library $tag', skip: !shotsEnabled, (tester) async {
        useShotDevice(tester);
        final c = await tester.runAsync(() => library(arabic));
        await tester.pumpWidget(
          framed(c!, Locale(lang), brightness, libraryFrame()),
        );
        await settleShot(tester);
        await saveShot(tester, 'phone-library-$tag');
      });

      testWidgets('channels $tag', skip: !shotsEnabled, (tester) async {
        useShotDevice(tester);
        final store = MemoryKeyValueStore();
        await store.setBool(backgroundChecksKey, true);
        final backend = FakeBackend();
        final names = arabic ? shotArabicChannels : shotEnglishChannels;
        for (final (i, name) in names.indexed) {
          backend.listings['https://www.youtube.com/@ch$i/videos'] = {
            '_type': 'playlist',
            'channel': name,
            'channel_id': 'UC_$i',
            'channel_follower_count': [184000, 52300, 1250000][i],
            'entries': [
              {'id': 'v$i', 'url': 'https://www.youtube.com/watch?v=v$i'},
            ],
          };
        }
        final c = container(store: store, [
          loggerProvider.overrideWithValue(
            VhLogger(filePath: '${Directory.systemTemp.path}/vh_shots.log'),
          ),
          downloadBackendProvider.overrideWithValue(backend),
          downloadEngineProvider.overrideWithValue(null),
          autoBackupProvider.overrideWithValue(_Backups()),
          channelArtProvider.overrideWithValue(_Art()),
          backgroundSchedulerProvider.overrideWithValue(_Scheduler()),
          backgroundStatusProvider.overrideWith(
            (ref) async => BackgroundStatus(
              lastRun: DateTime.now().subtract(const Duration(hours: 2)),
            ),
          ),
        ]);
        final source = LocalChannelSource(
          store: store,
          backend: backend,
          enqueue: (_, _, _) {},
        );
        await tester.runAsync(() async {
          for (var i = 0; i < names.length; i++) {
            await source.follow(
              'https://www.youtube.com/@ch$i',
              Quality.q1080,
              checkIntervalMinutes: [60, 360, 1440][i],
            );
          }
        });
        await tester.pumpWidget(
          framed(c, Locale(lang), brightness, const ChannelsScreen()),
        );
        await settleShot(tester);
        await saveShot(tester, 'phone-channels-$tag');
      });

      testWidgets('languages $tag', skip: !shotsEnabled, (tester) async {
        useShotDevice(tester);
        final c = container(const []);
        await tester.pumpWidget(
          framed(c, Locale(lang), brightness, const LanguageScreen()),
        );
        await settleShot(tester);
        await saveShot(tester, 'phone-languages-$tag');
      });

      // A tablet held sideways and upright: the rail in place of the bar.
      for (final (shape, size) in [
        ('wide', const Size(1280, 800)),
        ('tall', const Size(800, 1280)),
      ]) {
        testWidgets('tablet $shape $tag', skip: !shotsEnabled, (tester) async {
          useShotDevice(tester, size: size);
          final c = await tester.runAsync(() => library(arabic));
          // Sideways, a song plays in the panel beside the library.
          final port = FakeAudioPort();
          final handler = fakeAudioHandler(port);
          final song = shotLibrary(arabic)[4];
          await tester.runAsync(() async {
            await handler.playItems([
              PlaylistItem(
                canonicalUrl: song.key,
                title: song.title,
                uploader: (arabic
                    ? shotArabicChannels
                    : shotEnglishChannels)[2],
                artworkUrl: song.thumbnail,
                localPath: song.path,
                isAudio: true,
                duration: song.duration,
              ),
            ], startIndex: 0);
            await handler.pause();
          });
          await tester.pumpWidget(
            framed(
              c!,
              Locale(lang),
              brightness,
              libraryFrame(playing: shape == 'wide' ? handler : null),
            ),
          );
          await settleShot(tester);
          port.emit(const Duration(seconds: 71));
          await tester.pumpAndSettle();
          await saveShot(tester, 'tablet-$shape-$tag');
          await tester.runAsync(handler.dispose);
        });
      }
    }
  }
}

class _Scheduler implements BackgroundScheduler {
  @override
  Future<void> schedule({required bool on, bool soon = false}) async {}

  @override
  void answerRuns() {}
}

class _Backups implements AutoBackup {
  @override
  Future<void> requestBackup() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Art extends ChannelArt {
  _Art() : super(root: () async => Directory.systemTemp.path);

  @override
  Future<File?> file(String id, ChannelArtKind kind, String? url) async => null;
}
