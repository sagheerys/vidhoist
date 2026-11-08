import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../playback/fake_video_platform.dart';

/// **Guard: the chosen play mode under the video is filled with the ink**
/// (mobile plan, the video player): the action colour is for the one
/// thing to press, so a chosen chip is ink like every other chosen chip.
void main() {
  setUp(() {
    VideoPlayerPlatform.instance = FakeVideoPlatform();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null),
  );

  for (final (variant, day) in [
    (VhVariant.desktop, VhPalette.desktopDay),
    (VhVariant.phone, VhPalette.phoneDay),
  ]) {
    testWidgets('**the guard**: the chosen mode is ink, never the accent '
        '(${variant.name})', (tester) async {
      tester.view.physicalSize = const Size(1080, 2316);
      tester.view.devicePixelRatio = 2.8;
      addTearDown(tester.view.reset);
      final store = MemoryKeyValueStore();
      final mutex = PrefsMutex();
      final session = VhVideoSession(
        resolver: PlaybackSourceResolver(
          endpoint: ServerStreamEndpoint.none,
          fileExists: (_) => true,
        ),
        positions: PlaybackPositionStore(store: store, mutex: mutex),
        prefs: PlaybackPrefs(store: store, mutex: mutex),
        saveInterval: const Duration(hours: 1),
      );
      await tester.runAsync(
        () => session.open([
          const PlaylistItem(
            canonicalUrl: 'https://x/a',
            title: 'a',
            localPath: '/media/a.mp4',
          ),
        ]),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(variant, Brightness.light),
          home: Scaffold(body: VhVideoInfoSheet(session: session)),
        ),
      );
      await tester.pump();

      final label = vhPlayModeLabel(
        tester.element(find.byType(VhVideoInfoSheet)),
        session.playMode,
      );
      final chip = tester.widget<Material>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Material))
            .first,
      );
      expect(chip.color, day.ink);
      expect(chip.color, isNot(day.accentSoft));
      final text = tester.widget<Text>(find.text(label));
      expect(text.style!.color, day.bg);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(session.dispose);
    });
  }
}
