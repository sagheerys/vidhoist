import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import 'fake_video_platform.dart';

/// **The bar of a video held sideways**: the
/// time and buttons in one row, a thin bar under them along the bottom
/// edge, and the time said once.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    VideoPlayerPlatform.instance = FakeVideoPlatform();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null),
  );

  // A common phone held sideways.
  const screen = Size(823, 384);

  Future<VhVideoSession> show(
    WidgetTester tester,
    VhCaptions captions, {
    bool portrait = false,
  }) async {
    tester.view.physicalSize = (portrait ? screen.flipped : screen) * 3;
    tester.view.devicePixelRatio = 3;
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
      () => session.open(const [
        PlaylistItem(
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
        theme: vhTheme(VhVariant.phone, Brightness.light),
        home: portrait
            ? VhVideoScreen(session: session, captions: (_) => captions)
            : VhVideoFullscreenPage(
                session: session,
                captions: (_) => captions,
              ),
      ),
    );
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return session;
  }

  Future<void> leave(WidgetTester tester, VhVideoSession session) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(session.dispose);
  }

  testWidgets('**the guard**: the thin bar runs along the bottom edge, under '
      'the row that says the time once', (tester) async {
    final session = await show(
      tester,
      VhCaptions(
        lines: const [
          VhCaptionLine(
            start: Duration.zero,
            end: Duration(seconds: 9),
            text: 'a line said',
          ),
        ],
        shown: ValueNotifier(true),
      ),
    );
    final bar = tester.getRect(find.byType(Slider));
    final time = find.textContaining(' / ');
    expect(time, findsOneWidget);
    final row = tester.getRect(time);
    // Under the time, and near the edge of the screen.
    expect(bar.top, greaterThanOrEqualTo(row.bottom));
    expect(bar.bottom, greaterThan(screen.height - VhSpace.lg));
    // The slider no longer prints its own pair of times under the track.
    expect(find.text('0:00'), findsNothing);

    // The subtitle stays clear of the row while the controls show.
    final said = tester.getRect(find.textContaining('a line said').first);
    expect(said.bottom, lessThanOrEqualTo(row.top));
    await leave(tester, session);
  });

  testWidgets('**the guard**: under the video too, the thin bar is below '
      'the row, on the edge of the picture, clear of the light sheet', (
    tester,
  ) async {
    final session = await show(
      tester,
      VhCaptions(
        lines: const [
          VhCaptionLine(
            start: Duration.zero,
            end: Duration(seconds: 9),
            text: 'a line said',
          ),
        ],
        shown: ValueNotifier(true),
      ),
      portrait: true,
    );
    final bar = tester.getRect(find.byType(Slider));
    final row = tester.getRect(find.textContaining(' / '));
    final picture = tester.getRect(find.byType(VhVideoControls));
    expect(bar.top, greaterThanOrEqualTo(row.bottom));
    // The track, in the middle of the slider, above the sheet's 14px.
    expect(bar.center.dy, lessThan(picture.bottom - 14));
    expect(bar.bottom, greaterThan(picture.bottom - VhSpace.xl));
    // Edge to edge, as the picture is, with no margin kept for the handle
    //.
    expect(bar.left, picture.left);
    expect(bar.right, picture.right);
    final track = tester
        .widget<SliderTheme>(
          find
              .ancestor(
                of: find.byType(Slider),
                matching: find.byType(SliderTheme),
              )
              .first,
        )
        .data;
    expect(track.padding, EdgeInsets.zero);
    await leave(tester, session);
  });
}
