import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/add_flow.dart';
import 'package:vidhoist_mobile/features/home/link_preview_view.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'device_matrix.dart';

/// **The heights in the phone's add sheet** (owner's decisions of
/// 2026-11-04): a ceiling on every video site, with 360 offered here alone
/// so a phone can keep its downloads small, and none for sound alone.
void main() {
  late _Engine engine;

  Widget host(String url) {
    engine = _Engine();
    return ProviderScope(
      overrides: _overrides(engine),
      child: MaterialApp.router(
        theme: vhTheme(VhVariant.phone, Brightness.light),
        locale: const Locale('en'),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => Scaffold(
                body: Consumer(
                  builder: (context, ref, _) => TextButton(
                    onPressed: () =>
                        openAddSheet(context, ref, initialUrl: url),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
            GoRoute(path: '/batch', builder: (_, _) => const Scaffold()),
          ],
        ),
      ),
    );
  }

  Future<void> open(WidgetTester tester, String url) async {
    tester.view.physicalSize = const Size(411, 914);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host(url));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: 360 is offered, and goes with the download', (
    tester,
  ) async {
    await open(tester, 'https://www.youtube.com/watch?v=jNQXAC9IVRw');
    await tester.tap(find.text('Up to 360p'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start download'));
    await tester.pumpAndSettle();
    expect(engine.qualities, [Quality.q360]);
    expect(engine.clips, [null]);
  });

  group('only a part of the video', () {
    const yt = 'https://www.youtube.com/watch?v=jNQXAC9IVRw';

    Future<void> typed(WidgetTester tester, String from, String to) async {
      await open(tester, yt);
      expect(find.widgetWithText(TextField, 'From'), findsNothing);
      await tester.tap(find.text('Only a part of the video'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'From'), from);
      await tester.enterText(find.widgetWithText(TextField, 'To'), to);
      await tester.tap(find.text('Start download'));
      await tester.pumpAndSettle();
    }

    testWidgets('**the guard**: the stretch typed goes with the download', (
      tester,
    ) async {
      await typed(tester, '1:30', '٢:٤٥');
      expect(engine.clips, [
        const ClipRange(Duration(seconds: 90), Duration(seconds: 165)),
      ]);
      expect(find.text('Start download'), findsNothing);
    });

    testWidgets('times that do not read keep the sheet open and say why', (
      tester,
    ) async {
      await typed(tester, '2:00', '1:00');
      expect(engine.qualities, isEmpty);
      expect(find.text('After the start'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'From'), 'soon');
      await tester.pump();
      expect(find.text('Digits alone: 130 is 1:30'), findsOneWidget);
    });

    // Samsung's number pad has no colon: before this, `130` read as 130
    // seconds, and a time past a minute could not be typed there.
    testWidgets('**the guard**: digits alone are a time, the colon put in', (
      tester,
    ) async {
      await typed(tester, '130', '٢٤٥');
      expect(engine.clips, [
        const ClipRange(Duration(seconds: 90), Duration(seconds: 165)),
      ]);
    });

    testWidgets('the arrows move a minute; "to" starts from "from"', (
      tester,
    ) async {
      await open(tester, yt);
      await tester.tap(find.text('Only a part of the video'));
      await tester.pumpAndSettle();
      Finder arrow(String field, String label) => find.descendant(
        of: find.widgetWithText(TextField, field),
        matching: find.bySemanticsLabel(label),
      );
      await tester.tap(arrow('From', 'A minute earlier'));
      await tester.tap(arrow('From', 'A minute later'));
      await tester.tap(arrow('From', 'A minute later'));
      await tester.pump();
      expect(find.text('2:00'), findsOneWidget);
      await tester.tap(arrow('To', 'A minute later'));
      await tester.pump();
      expect(find.text('3:00'), findsOneWidget);
      await tester.tap(find.text('Start download'));
      await tester.pumpAndSettle();
      expect(engine.clips, [
        const ClipRange(Duration(minutes: 2), Duration(minutes: 3)),
      ]);
    });
  });

  testWidgets('another video site offers the heights too', (tester) async {
    await open(tester, 'https://www.tiktok.com/@u/video/7301234567890123456');
    expect(find.text('Up to 720p'), findsOneWidget);
    expect(find.text('Up to 360p'), findsOneWidget);
  });

  testWidgets('sound alone offers no heights', (tester) async {
    await open(tester, 'https://soundcloud.com/artist/track');
    expect(find.text('Up to 720p'), findsNothing);
    expect(find.text('Up to 360p'), findsNothing);
  });

  testWidgets('the sheet with its six choices holds on every device', (
    tester,
  ) async {
    await expectNoOverflow(tester, () => const _Opened());
  });
}

List<Override> _overrides(LocalDownloadEngine? engine) => [
  keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
  secretStoreProvider.overrideWithValue(MemorySecretStore()),
  prefsMutexProvider.overrideWithValue(PrefsMutex()),
  initialSettingsProvider.overrideWithValue(const PhoneSettings()),
  loggerProvider.overrideWithValue(
    VhLogger(filePath: '${Directory.systemTemp.path}/mtf_test.log'),
  ),
  downloadEngineProvider.overrideWithValue(engine),
  linkPreviewResolverProvider.overrideWithValue(
    ClipPreviewResolver(httpGet: (_) async => '{}'),
  ),
];

/// The sheet, opened once per size by the device matrix.
class _Opened extends StatelessWidget {
  const _Opened();

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: _overrides(null),
    child: MaterialApp.router(
      theme: vhTheme(VhVariant.phone, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => const _OpensSheet())],
      ),
    ),
  );
}

class _OpensSheet extends ConsumerStatefulWidget {
  const _OpensSheet();

  @override
  ConsumerState<_OpensSheet> createState() => _OpensSheetState();
}

class _OpensSheetState extends ConsumerState<_OpensSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => openAddSheet(
        context,
        ref,
        initialUrl: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

class _Engine implements LocalDownloadEngine {
  final qualities = <Quality>[];
  final clips = <ClipRange?>[];

  @override
  DownloadTask submit(
    String url,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
    ClipRange? clip,
  }) {
    qualities.add(quality);
    clips.add(clip);
    return DownloadTask(inputUrl: url, quality: quality, folder: folder);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
