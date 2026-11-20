@Tags(['shots'])
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/shots.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/audio/audio_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/player/playback_providers.dart';
import 'package:vidhoist_mobile/features/player/player_screen.dart';
import 'package:vidhoist_mobile/features/player/sidecar_subtitles.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

import '../fake_audio_port.dart';

/// **The phone's players for the project's pages**: the music player with
/// what is said under it, and the video player with a still in place of
/// the film, which a test cannot decode. As `phone_shots_test.dart`, run
/// only with `VH_SHOTS=1`.
void main() {
  final enabled = Platform.environment['VH_SHOTS'] != null;
  final root = Directory.current.parent.parent.path;
  final covers = '$root/tool/screenshots/covers';
  final out = '$root/docs/screenshots';

  setUpAll(() async {
    if (!enabled) return;
    await loadVhFonts('$root/packages/vh_ui/assets/fonts');
    initVhL10n();
  });

  void phone(WidgetTester tester) {
    debugDisableShadows = false;
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2;
    // A phone's status bar and gesture bar, which the frame draws over.
    tester.view.padding = const FakeViewPadding(top: 56, bottom: 36);
    tester.view.viewPadding = const FakeViewPadding(top: 56, bottom: 36);
    addTearDown(tester.view.reset);
  }

  /// [still] waits a fixed while: the video's controls keep a clock
  /// running, so the screen never settles.
  Future<void> settle(WidgetTester tester, {bool still = true}) async {
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 250)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    if (still) await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester, String name) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('shot')),
    );
    await tester.runAsync(() => saveVhShot(boundary, '$out/$name.png'));
    debugDisableShadows = true;
    // The players' timers end with the screen, before the test checks
    // that none is left.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
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

  for (final lang in ['ar', 'en']) {
    for (final brightness in Brightness.values) {
      final arabic = lang == 'ar';
      final tag = '$lang-${brightness == Brightness.dark ? 'night' : 'day'}';

      testWidgets('audio $tag', skip: !enabled, (tester) async {
        phone(tester);
        final port = FakeAudioPort();
        final handler = fakeAudioHandler(port);
        final song = PlaylistItem(
          canonicalUrl: 'https://vimeo.com/900004',
          title: arabic ? 'ألحان المساء' : 'Evening tunes',
          uploader: arabic ? 'رحّالة' : 'The Wanderer',
          artworkUrl: '$covers/music.jpg',
          localPath: '/media/evening.m4a',
          isAudio: true,
          duration: const Duration(minutes: 4, seconds: 31),
        );
        final next = PlaylistItem(
          canonicalUrl: 'https://vimeo.com/900001',
          title: arabic ? 'إبحار هادئ' : 'A quiet sail',
          artworkUrl: '$covers/sea.jpg',
          localPath: '/media/sail.m4a',
          isAudio: true,
        );
        final c = ProviderContainer(
          overrides: [
            keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            prefsMutexProvider.overrideWithValue(PrefsMutex()),
            initialSettingsProvider.overrideWithValue(const PhoneSettings()),
            audioHandlerProvider.overrideWithValue(handler),
            localMediaProvider.overrideWith((ref) async => const []),
            subtitleCacheProvider.overrideWith(
              () => _Read({
                song.localPath!: {lang: _lines(arabic)},
              }),
            ),
          ],
        );
        addTearDown(c.dispose);
        await tester.runAsync(() async {
          await handler.playItems([song, next], startIndex: 0);
          await handler.pause();
        });
        await tester.pumpWidget(
          framed(c, Locale(lang), brightness, const AudioScreen()),
        );
        await settle(tester);
        port.emit(const Duration(seconds: 71));
        await tester.pumpAndSettle();
        await save(tester, 'phone-audio-$tag');
        await tester.runAsync(handler.dispose);
      });

      testWidgets('video $tag', skip: !enabled, (tester) async {
        phone(tester);
        VideoPlayerPlatform.instance = _StillVideo('$covers/mountains.jpg');
        final handler = fakeAudioHandler(FakeAudioPort());
        final clip = PlaylistItem(
          canonicalUrl: 'https://vimeo.com/900000',
          title: arabic
              ? 'رحلة إلى جبال السروات في موسم الضباب'
              : 'Into the misty mountains at dawn',
          uploader: arabic ? 'عدسة الجنوب' : 'Southern Lens',
          artworkUrl: '$covers/mountains.jpg',
          localPath: '/media/mountains.mp4',
          duration: const Duration(minutes: 14, seconds: 7),
        );
        final c = ProviderContainer(
          overrides: [
            keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            prefsMutexProvider.overrideWithValue(PrefsMutex()),
            initialSettingsProvider.overrideWithValue(const PhoneSettings()),
            audioHandlerProvider.overrideWithValue(handler),
            localMediaProvider.overrideWith((ref) async => const []),
            playbackResolverProvider.overrideWithValue(
              PlaybackSourceResolver(
                endpoint: ServerStreamEndpoint.none,
                fileExists: (_) => true,
              ),
            ),
            playbackRequestProvider.overrideWith(
              (ref) => PlaybackRequest(items: [clip], startIndex: 0),
            ),
            subtitleCacheProvider.overrideWith(
              () => _Read({
                clip.localPath!: {lang: _lines(arabic)},
              }),
            ),
          ],
        );

        await tester.pumpWidget(
          framed(c, Locale(lang), brightness, const PlayerScreen()),
        );
        await settle(tester, still: false);
        await save(tester, 'phone-video-$tag');
        // The session's clock stops with its provider, which goes with
        // the container: before the test checks that no timer is left.
        c.dispose();
        await tester.runAsync(handler.dispose);
      });
    }
  }
}

List<VhCaptionLine> _lines(bool arabic) => [
  for (final (i, text) in (arabic ? _arabic : _english).indexed)
    VhCaptionLine(
      start: Duration(seconds: 60 + i * 7),
      end: Duration(seconds: 66 + i * 7),
      text: text,
    ),
];

const _arabic = [
  'نبدأ الرحلة قبل الفجر، والضباب يغطي الوادي كله.',
  'كلما صعدنا قليلاً انكشفت القمم واحدة بعد الأخرى.',
  'هذه أشجار العرعر، وعمر بعضها مئات السنين.',
  'نتوقف هنا لنشرب القهوة وننتظر شروق الشمس.',
];

const _english = [
  'We set out before dawn, with mist filling the whole valley.',
  'With every turn of the path another peak comes into view.',
  'These are juniper trees, some of them hundreds of years old.',
  'We stop here for coffee and wait for the sun to rise.',
];

class _Read extends SubtitleCache {
  _Read(this.read);

  final Map<String, Map<String, List<VhCaptionLine>>> read;

  @override
  Map<String, Map<String, List<VhCaptionLine>>> build() => read;
}

/// `video_player` with a still for every film: it says the clip is ready,
/// 16:9 and paused, and draws [still] where the picture goes.
class _StillVideo extends VideoPlayerPlatform {
  _StillVideo(this.still);

  final String still;
  int _next = 0;
  final _events = <int, StreamController<VideoEvent>>{};

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    final id = _next++;
    late final StreamController<VideoEvent> events;
    events = StreamController<VideoEvent>.broadcast(
      onListen: () => scheduleMicrotask(() {
        if (events.isClosed) return;
        events.add(
          VideoEvent(
            eventType: VideoEventType.initialized,
            duration: const Duration(minutes: 14, seconds: 7),
            size: const Size(1920, 1080),
          ),
        );
      }),
    );
    _events[id] = events;
    return id;
  }

  @override
  Future<void> dispose(int playerId) async => _events.remove(playerId)?.close();

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) =>
      _events[playerId]?.stream ?? const Stream.empty();

  @override
  Future<void> play(int playerId) async {}

  @override
  Future<void> pause(int playerId) async {}

  @override
  Future<void> setLooping(int playerId, bool looping) async {}

  @override
  Future<void> setVolume(int playerId, double volume) async {}

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}

  @override
  Future<void> seekTo(int playerId, Duration position) async {}

  @override
  Future<Duration> getPosition(int playerId) async =>
      const Duration(minutes: 1, seconds: 12);

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}

  @override
  Widget buildView(int playerId) => _picture();

  @override
  Widget buildViewWithOptions(VideoViewOptions options) => _picture();

  Widget _picture() => Image.file(File(still), fit: BoxFit.cover);
}
