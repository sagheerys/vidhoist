import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/taskbar_data.dart';
import 'package:vidhoist_desktop/features/add/links_view.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_button.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_panel.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

/// The downloads panel on the engine of this computer: each phase in its
/// own words, a running clip paused and a paused one resumed, and a
/// paused clip not counted as under way, on the button or the taskbar.
void main() {
  const reel = 'https://www.instagram.com/reel/abc/';
  final l = lookupVhLocalizations(const Locale('en'));

  group('each phase in its own words', () {
    DownloadTask at(TaskPhase phase, {double progress = 0}) => DownloadTask(
      inputUrl: reel,
      quality: Quality.best,
      phase: phase,
      progress: progress,
    );

    test('reading the link, arriving, finishing, paused', () {
      expect(taskLine(l, at(TaskPhase.preparing)), l.enginePreparing);
      expect(
        taskLine(l, at(TaskPhase.downloading, progress: 0.42)),
        l.engineDownloadingProgress(42),
      );
      expect(taskLine(l, at(TaskPhase.postprocessing)), l.enginePostprocessing);
      expect(taskLine(l, at(TaskPhase.paused)), l.enginePaused);
    });
  });

  Future<ShellHarness> open(WidgetTester tester, {Size? size}) async {
    ShellHarness.useWindow(tester, size ?? const Size(1440, 900));
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object?>{'text': ''}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final h = ShellHarness(library: const [], withEngine: true);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    return h;
  }

  Future<void> openPanel(WidgetTester tester) async {
    await tester.tap(find.byType(DownloadsButton));
    await tester.pumpAndSettle();
  }

  Finder inPanel(Finder finder) =>
      find.descendant(of: find.byType(DownloadsPanel), matching: finder);

  testWidgets('a running clip shows its share and pauses', (tester) async {
    final h = await open(tester);
    final task = h.engine.submit(reel, Quality.best);
    h.engine.advance(task, 0.4);
    await tester.pumpAndSettle();
    await openPanel(tester);
    expect(inPanel(find.text(l.desktopDownloadsRunning)), findsOneWidget);
    expect(inPanel(find.text(l.engineDownloadingProgress(40))), findsOneWidget);
    await tester.tap(inPanel(find.text(l.pause)));
    await tester.pumpAndSettle();
    expect(h.engine.paused, [task.id]);
  });

  testWidgets('a paused clip waits under its own heading and resumes', (
    tester,
  ) async {
    final h = await open(tester);
    final task = h.engine.submit(reel, Quality.best);
    h.engine.put(task.copyWith(phase: TaskPhase.paused, progress: 0.3));
    await tester.pumpAndSettle();
    // Not under way: the button counts nothing.
    expect(byLabel(l.desktopDownloads), findsOneWidget);
    await openPanel(tester);
    expect(inPanel(find.text(l.enginePaused)), findsWidgets);
    await tester.tap(inPanel(find.text(l.engineResume)));
    await tester.pumpAndSettle();
    expect(h.engine.resumed, [task.id]);
  });

  testWidgets('the taskbar counts what runs, not what is paused', (
    tester,
  ) async {
    final h = await open(tester);
    final running = h.engine.submit(reel, Quality.best);
    h.engine.advance(running, 0.5);
    final paused = h.engine.submit('$reel?2', Quality.best);
    h.engine.put(paused.copyWith(phase: TaskPhase.paused));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    final downloads = container.read(taskbarDownloadsProvider);
    expect(downloads.count, 1);
    expect(downloads.progress, closeTo(0.5, 1e-9));
  });

  for (final night in [false, true]) {
    testWidgets('the panel fits at 960 and 1440, '
        '${night ? 'night' : 'day'}', (tester) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => call.method == 'Clipboard.getData'
            ? <String, Object?>{'text': ''}
            : null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      late ShellHarness h;
      await expectNoOverflow(
        tester,
        () {
          h = ShellHarness(library: const [], withEngine: true, night: night);
          return h.app();
        },
        then: (tester) async {
          final a = h.engine.submit(reel, Quality.best);
          h.engine.advance(a, 0.4);
          final b = h.engine.submit('$reel?2', Quality.q720);
          h.engine.put(b.copyWith(phase: TaskPhase.paused, progress: 0.2));
          // Waiting its turn; a phase with the moving strip never settles.
          h.engine.submit('$reel?3', Quality.audio);
          await tester.pumpAndSettle();
          await openPanel(tester);
        },
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
    });
  }
}
