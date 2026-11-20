@Tags(['shots'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/shots.dart';
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
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/language_screen.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

/// **The phone's screenshots for the project's pages**, made from the app's
/// own widgets with its own fonts and covers drawn for the purpose
/// (`tool/screenshots/make_covers.py`), so they show nobody's clips.
///
/// Not part of the test run: `VH_SHOTS=1 flutter test test/screenshots`
/// writes them to `docs/screenshots/`.
void main() {
  final enabled = Platform.environment['VH_SHOTS'] != null;
  final root = Directory.current.parent.parent.path;
  final covers = '$root/tool/screenshots/covers';
  final out = '$root/docs/screenshots';

  setUpAll(() async {
    if (!enabled) return;
    await loadVhFonts('$root/packages/vh_ui/assets/fonts');
    // The relative times in each language, as the app's main sets them.
    initVhL10n();
  });

  /// A phone of 360 by 800 points, saved at twice that, with real
  /// shadows: tests draw each as a black outline unless told otherwise.
  void phone(WidgetTester tester) {
    debugDisableShadows = false;
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<void> settle(WidgetTester tester) async {
    // Covers are files: read and decoded outside the test's clock.
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 250)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester, String name) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('shot')),
    );
    await tester.runAsync(() => saveVhShot(boundary, '$out/$name.png'));
    // Back to the tests' own setting, which the framework checks at the end.
    debugDisableShadows = true;
  }

  Widget framed(
    ProviderContainer c,
    Locale locale,
    Brightness brightness,
    Widget home,
  ) => UncontrolledProviderScope(
    container: c,
    child: RepaintBoundary(
      key: const ValueKey('shot'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: vhTheme(
          VhVariant.phone,
          brightness,
          language: locale.languageCode,
        ),
        home: home,
      ),
    ),
  );

  List<LocalItem> library(bool arabic) {
    final clips = arabic ? _arabicClips : _englishClips;
    return [
      for (final (i, (title, cover, minutes, audio)) in clips.indexed)
        LocalItem(
          key: 'https://www.example.com/clip$i',
          canonicalUrl: 'https://www.example.com/clip$i',
          path:
              '/storage/emulated/0/Download/VidHoist/clip$i.'
              '${audio ? 'm4a' : 'mp4'}',
          title: title,
          sizeBytes: (minutes * 9.5 * 1000000).round(),
          modified: DateTime.now().subtract(Duration(hours: 3 + i * 9)),
          thumbnail: '$covers/$cover.jpg',
          duration: Duration(minutes: minutes, seconds: 7 + i * 6),
        ),
    ];
  }

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

  for (final lang in ['ar', 'en']) {
    for (final brightness in Brightness.values) {
      final tag = '$lang-${brightness == Brightness.dark ? 'night' : 'day'}';

      testWidgets('library $tag', skip: !enabled, (tester) async {
        phone(tester);
        final store = MemoryKeyValueStore();
        await store.setString('library_view_mode', LibraryViewMode.grid.name);
        final c = container(store: store, [
          mediaAccessGateProvider.overrideWithValue(
            MediaAccessGate(
              probe: () async => true,
              isGranted: (_) async => true,
              ask: (_) async => true,
            ),
          ),
          localMediaProvider.overrideWith((ref) async => library(lang == 'ar')),
        ]);
        await tester.pumpWidget(
          framed(
            c,
            Locale(lang),
            brightness,
            Builder(
              builder: (context) => VhAdaptiveScaffold(
                items: shellNavItems(context.vhl, shellTabs(paired: false)),
                selectedIndex: 0,
                onSelected: (_) {},
                body: const LibraryScreen(),
                floatingActionButton: VhFab(
                  label: context.vhl.addLinkFab,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );
        await settle(tester);
        await save(tester, 'phone-library-$tag');
      });

      testWidgets('channels $tag', skip: !enabled, (tester) async {
        phone(tester);
        final store = MemoryKeyValueStore();
        await store.setBool(backgroundChecksKey, true);
        final backend = FakeBackend();
        final names = lang == 'ar' ? _arabicChannels : _englishChannels;
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
        final c = ProviderContainer(
          overrides: [
            keyValueStoreProvider.overrideWithValue(store),
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            prefsMutexProvider.overrideWithValue(PrefsMutex()),
            initialSettingsProvider.overrideWithValue(const PhoneSettings()),
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
          ],
        );
        addTearDown(c.dispose);
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
        await settle(tester);
        await save(tester, 'phone-channels-$tag');
      });

      testWidgets('languages $tag', skip: !enabled, (tester) async {
        phone(tester);
        final c = container(const []);
        await tester.pumpWidget(
          framed(c, Locale(lang), brightness, const LanguageScreen()),
        );
        await settle(tester);
        await save(tester, 'phone-languages-$tag');
      });
    }
  }
}

const _arabicClips = [
  ('رحلة إلى جبال السروات في موسم الضباب', 'mountains', 14, false),
  ('إبحار هادئ على ساحل البحر الأحمر', 'sea', 9, false),
  ('المدينة في الليل: جولة بين الأبراج', 'city', 22, false),
  ('طبق الخضار المشوي في عشر دقائق', 'kitchen', 6, false),
  ('ألحان المساء', 'music', 4, true),
  ('كثبان الربع الخالي عند الغروب', 'desert', 18, false),
  ('غابات الشمال: نزهة طويلة', 'forest', 31, false),
  ('ألوان الشفق القطبي', 'aurora', 3, false),
];

const _englishClips = [
  ('Into the misty mountains at dawn', 'mountains', 14, false),
  ('A quiet sail along the coast', 'sea', 9, false),
  ('The city at night: a walk between towers', 'city', 22, false),
  ('Roasted vegetables in ten minutes', 'kitchen', 6, false),
  ('Evening tunes', 'music', 4, true),
  ('Dunes of the Empty Quarter at sunset', 'desert', 18, false),
  ('Northern forests: a long hike', 'forest', 31, false),
  ('Colours of the aurora', 'aurora', 3, false),
];

const _arabicChannels = ['عدسة الجنوب', 'مطبخ البيت', 'رحّالة'];
const _englishChannels = ['Southern Lens', 'Home Kitchen', 'The Wanderer'];

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
