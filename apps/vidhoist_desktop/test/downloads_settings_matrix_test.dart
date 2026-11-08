import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/data/update_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_button.dart';
import 'package:vidhoist_desktop/features/settings/whats_new.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

class _Folders extends NoFolders {
  const _Folders();

  // Long on purpose: a OneDrive Videos folder with a long user name.
  @override
  Future<String?> videos() async =>
      r'C:\Users\a.very.long.user.name\OneDrive - Company Name\Videos';

  @override
  Future<String?> downloads() async => r'C:\Users\me\Downloads';
}

/// Long on purpose, in both scripts.
const _longTitle =
    'A very long title about replicating snapshots to a second box every '
    'single night, and why a snapshot on the same pool is not a backup';

final _library = [
  LibraryItem(
    canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
    title: _longTitle,
    uploader: 'A channel with a rather long name of its own',
    timestamp: DateTime(2026, 10, 20),
  ),
  LibraryItem(
    canonicalUrl: 'https://youtu.be/bbbbbbbbbbb',
    title: 'نسخ اللقطات إلى صندوق ثانٍ كل ليلة، ولماذا لا تكفي اللقطة وحدها',
    timestamp: DateTime(2026, 10, 21),
  ),
];

TranscriptIndex _index() => TranscriptIndex()
  ..add(
    Transcript(
      canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
      language: 'en',
      source: 'sidecar',
      fetchedAt: DateTime(2026, 10, 24),
      segments: [
        TranscriptSegment(
          start: const Duration(hours: 1, minutes: 2, seconds: 3),
          end: const Duration(hours: 1, minutes: 2, seconds: 9),
          text:
              'So we replicate the snapshots to a second box every night, '
              'because a snapshot on the same pool goes down with the pool.',
        ),
      ],
    ),
  );

ShellHarness _harness({List<LibraryItem> library = const []}) => ShellHarness(
  library: library,
  withEngine: true,
  overrides: [
    desktopFoldersProvider.overrideWithValue(const _Folders()),
    // A log that is never written: the pane shows its empty state.
    loggerProvider.overrideWithValue(VhLogger(filePath: 'no-such-log.txt')),
    installedVersionProvider.overrideWith((ref) async => '0.12.10'),
    transcriptIndexProvider.overrideWith((ref) async => _index()),
  ],
);

void main() {
  for (final pane in [
    'downloads',
    'folders',
    'desktop',
    'backup',
    'cookies',
    'logs',
    'about',
    'subscriptions',
    'appearance',
    'transcripts',
    'updates',
  ]) {
    testWidgets('settings: $pane', (tester) async {
      await expectNoOverflow(
        tester,
        _harness().app,
        then: (tester) async {
          GoRouter.of(tester.element(find.byType(DesktopSidebar)))
              .go('/settings/$pane');
        },
      );
    });
  }

  testWidgets('settings: updates, with a version found and long notes', (
    tester,
  ) async {
    await expectNoOverflow(
      tester,
      () => ShellHarness(
        library: const [],
        withEngine: true,
        overrides: [
          installedVersionProvider.overrideWith((ref) async => '0.12.10'),
          updateProvider.overrideWith(_Found.new),
        ],
      ).app(),
      then: (tester) async {
        GoRouter.of(tester.element(find.byType(DesktopSidebar)))
            .go('/settings/updates');
      },
    );
  });

  testWidgets('the downloads panel, full', (tester) async {
    await expectNoOverflow(
      tester,
      () {
        final h = _harness();
        final waiting = h.engine.submit(
          'https://www.youtube.com/watch?v=aaaaaaaaaaa',
          Quality.best,
        );
        h.engine.fail(
          h.engine.submit('https://x.com/a/status/1', Quality.best),
          const NetworkException('dropped'),
        );
        expect(waiting.phase, TaskPhase.queued);
        return h.app();
      },
      then: (tester) async {
        await tester.tap(find.byType(DownloadsButton));
      },
    );
  });

  testWidgets('the palette, with every kind of result', (tester) async {
    await expectNoOverflow(
      tester,
      () => _harness(library: _library).app(),
      then: (tester) async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pumpAndSettle();
        // The commands were drawn on opening; now a title, a moment with
        // an hour in its time, and saving.
        await tester.enterText(find.byType(TextField).last, 'snapshot');
      },
    );
  });

  testWidgets("what's new, in the middle of the window", (tester) async {
    await expectNoOverflow(
      tester,
      () => _harness().app(),
      then: (tester) async {
        unawaited(
          showWhatsNewDialog(
            tester.element(find.byType(DesktopSidebar)),
            const WhatsNew(
              version: '0.12.10',
              notes: '## Fixed\n- $_longTitle\n- $_longTitle',
              pageUrl: 'https://example.com/releases/tag/v0.12.10',
            ),
          ),
        );
      },
    );
  });
}

/// A version already found, with notes long enough to wrap.
class _Found extends UpdateNotifier {
  @override
  UpdateState build() => UpdateState(
    phase: UpdatePhase.available,
    release: UpdateRelease(
      version: AppVersion.tryParse('0.13.0')!,
      tag: 'v0.13.0',
      apkUrl: 'https://x/setup.exe',
      apkSize: 28000000,
      notes:
          '## Fixed\n- ${'The palette opens at once, and the reading room '
                  'keeps its place when the window is resized. ' * 3}\n'
          '## Added\n- Updates install themselves.',
    ),
  );
}
