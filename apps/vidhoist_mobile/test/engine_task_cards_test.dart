import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/downloads_sheet.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/task_card_parts.dart';

/// The cards in the phone engine's own words: reading the link, the bytes
/// with their speed, finishing the file, paused; and pause and resume
/// beside the cancel.
void main() {
  final l10n = lookupMTLocalizations(const Locale('en'));
  DownloadTask at(TaskPhase phase) => DownloadTask(
    inputUrl: 'https://youtu.be/abc',
    quality: Quality.best,
  ).copyWith(phase: phase);

  test('each phase of the phone engine says what it is doing', () {
    expect(taskStatusText(l10n, at(TaskPhase.preparing)), l10n.enginePreparing);
    expect(
      taskStatusText(l10n, at(TaskPhase.downloading)),
      l10n.downloadingTitle,
    );
    expect(
      taskStatusText(l10n, at(TaskPhase.postprocessing)),
      l10n.enginePostprocessing,
    );
    expect(taskStatusText(l10n, at(TaskPhase.paused)), l10n.enginePaused);
    expect(
      taskStatusText(l10n, at(TaskPhase.waitingForNetwork)),
      l10n.waitingForWifi,
    );
    // Paused because Wi-Fi went, not by hand.
    expect(
      taskStatusText(l10n, at(TaskPhase.paused), waitingForWifi: true),
      l10n.waitingForWifi,
    );
  });

  test('the speed shows while the bytes arrive', () {
    final fast = at(TaskPhase.downloading).copyWith(speed: () => 2 * 1048576);
    expect(taskSpeed(fast), contains('2.0 MB/s'));
    expect(taskSpeed(at(TaskPhase.preparing)), isNull);
  });

  test('the notification body names the phase, with the percentage while '
      'downloading', () {
    expect(
      taskNotificationText(
        l10n,
        at(TaskPhase.downloading).copyWith(progress: 0.42),
      ),
      l10n.engineDownloadingProgress('42'),
    );
    expect(
      taskNotificationText(l10n, at(TaskPhase.preparing)),
      l10n.enginePreparing,
    );
  });

  testWidgets('pause stops a running download, and resume sends it on', (
    tester,
  ) async {
    final backend = FakeBackend(hold: true);
    final engine = LocalDownloadEngine(
      backend: backend,
      folderFor: (_) => '/downloads',
    );
    addTearDown(engine.dispose);
    final task = engine.submit('https://youtu.be/abc', Quality.best);
    await tester.runAsync(() async {
      while (!backend.isHeld(task.id)) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [downloadEngineProvider.overrideWithValue(engine)],
        child: MaterialApp(
          theme: mtTheme(MTVariant.lite, Brightness.light),
          localizationsDelegates: MTLocalizations.localizationsDelegates,
          supportedLocales: MTLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDownloadsSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(l10n.pause));
    await tester.pumpAndSettle();
    expect(engine.taskById(task.id)!.phase, TaskPhase.paused);
    expect(find.text(l10n.enginePaused), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.engineResume));
    await tester.pump();
    expect(engine.taskById(task.id)!.phase, isNot(TaskPhase.paused));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    expect(backend.requests, hasLength(2));
  });
}
