import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/appearance_data.dart';
import 'package:vidhoist_desktop/data/backup_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/data/update_data.dart';
import 'package:vidhoist_desktop/features/welcome/startup_offers.dart';
import 'package:vidhoist_desktop/features/welcome/welcome_dialog.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

/// The first start opens the welcome rather than Discover: where
/// downloads go, the language, and the engine, with ffmpeg and Deno
/// offered at once. Once, and never again.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late List<EnginePart> asked;

  setUp(() => asked = []);

  ShellHarness harness({bool welcome = true, List<Override> more = const []}) =>
      ShellHarness(
        library: const [],
        overrides: [
          offerWelcomeProvider.overrideWithValue(welcome),
          offerWhatsNewProvider.overrideWithValue(false),
          installedVersionProvider.overrideWith((ref) async => '1.0.0'),
          engineLocatorProvider.overrideWithValue(
            EngineLocator(
              ownFolder: r'C:\e',
              pathFolders: const [],
              exists: (path) => path == r'C:\e\yt-dlp\yt-dlp.exe',
            ),
          ),
          downloadBackendProvider.overrideWithValue(FakeBackend()),
          engineFetchProvider.overrideWith(() => _Fetches(asked)),
          ...more,
        ],
      );

  void quietClipboard(WidgetTester tester) {
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
  }

  testWidgets('**the guard**: the first start welcomes, once', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    quietClipboard(tester);
    final h = harness();
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    expect(find.text(l.desktopWelcomeTitle), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(WelcomeDialog),
        matching: find.textContaining('2026.10.26'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text(l.desktopWelcomeStart));
    await tester.pumpAndSettle();
    expect(find.text(l.desktopWelcomeTitle), findsNothing);
    expect(await h.store.getBool(welcomedKey), isTrue);

    // The next start goes straight to the library.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    expect(find.text(l.desktopWelcomeTitle), findsNothing);
  });

  group('the first start after a reinstall, with a backup waiting', () {
    final newest = BackupFile(
      path: r'C:\Downloads\VidHoist\Backups\vidhoist_2026-11-11_200000.json',
      name: 'vidhoist_2026-11-11_200000.json',
      at: DateTime.now().subtract(const Duration(hours: 3)),
      sizeBytes: 4096,
    );

    testWidgets('**the guard**: the backup is offered before the welcome, '
        'and restoring it skips the welcome', (tester) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      quietClipboard(tester);
      final restored = <BackupFile>[];
      final h = harness(
        more: [
          backupsProvider.overrideWith(
            (ref) => _Backups(ref, [newest], restored),
          ),
        ],
      );
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      expect(find.text(l.desktopRestoreOfferTitle), findsOneWidget);
      expect(find.text(l.desktopWelcomeTitle), findsNothing);

      await tester.tap(find.text(l.desktopRestore));
      await tester.pumpAndSettle();
      expect(restored, [newest]);
      expect(find.text(l.desktopWelcomeTitle), findsNothing);
      expect(await h.store.getBool(welcomedKey), isTrue);
    });

    testWidgets('starting fresh goes on to the welcome, and restores nothing', (
      tester,
    ) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      quietClipboard(tester);
      final restored = <BackupFile>[];
      await tester.pumpWidget(
        harness(
          more: [
            backupsProvider.overrideWith(
              (ref) => _Backups(ref, [newest], restored),
            ),
          ],
        ).app(),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.desktopStartFresh));
      await tester.pumpAndSettle();
      expect(restored, isEmpty);
      expect(find.text(l.desktopWelcomeTitle), findsOneWidget);
    });

    testWidgets('with no backup, the welcome as before', (tester) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      quietClipboard(tester);
      await tester.pumpWidget(
        harness(
          more: [
            backupsProvider.overrideWith((ref) => _Backups(ref, const [], [])),
          ],
        ).app(),
      );
      await tester.pumpAndSettle();
      expect(find.text(l.desktopRestoreOfferTitle), findsNothing);
      expect(find.text(l.desktopWelcomeTitle), findsOneWidget);
    });
  });

  testWidgets('it fetches ffmpeg and Deno when asked', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    quietClipboard(tester);
    await tester.pumpWidget(harness().app());
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopWelcomeFetchNow));
    await tester.pumpAndSettle();
    expect(asked, [EnginePart.ffmpeg, EnginePart.deno]);
  });

  testWidgets('the language chosen here is the app\'s', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    quietClipboard(tester);
    final h = harness();
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    await tester.tap(find.text(vhLanguageName('ar')));
    await tester.pumpAndSettle();
    final element = tester.element(find.byType(WelcomeDialog));
    final container = ProviderScope.containerOf(element);
    expect(container.read(appearanceProvider).locale, 'ar');
  });

  testWidgets('not offered where the app does not ask (tests, the lab)', (
    tester,
  ) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    quietClipboard(tester);
    await tester.pumpWidget(harness(welcome: false).app());
    await tester.pumpAndSettle();
    expect(find.text(l.desktopWelcomeTitle), findsNothing);
  });

  for (final night in [false, true]) {
    testWidgets('fits at 960 and 1440, both languages, '
        '${night ? 'night' : 'day'}', (tester) async {
      quietClipboard(tester);
      await expectNoOverflow(
        tester,
        () => harness(
          more: [
            initialAppearanceProvider.overrideWithValue((
              theme: night ? ThemeMode.dark : ThemeMode.light,
              locale: null,
            )),
          ],
        ).app(),
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
    });
  }
}

/// Backups that exist without a disk: [list] gives [files], and a restore
/// is recorded rather than read.
class _Backups extends DesktopBackups {
  _Backups(super.ref, this.files, this.restored);

  final List<BackupFile> files;
  final List<BackupFile> restored;

  @override
  Future<List<BackupFile>> list() async => files;

  @override
  Future<void> restore(BackupFile file) async => restored.add(file);

  @override
  Future<BackupFile?> backUpNow() async => null;
}

class _Fetches extends EngineFetchNotifier {
  _Fetches(this.asked);

  final List<EnginePart> asked;

  @override
  Future<bool> fetch(EnginePart part) async {
    asked.add(part);
    return true;
  }
}
