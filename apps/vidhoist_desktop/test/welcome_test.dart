import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/appearance_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/data/update_data.dart';
import 'package:vidhoist_desktop/features/welcome/startup_offers.dart';
import 'package:vidhoist_desktop/features/welcome/welcome_dialog.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

/// The first start opens the welcome, in place of the server setup and
/// Discover: where downloads go, the language, and the engine, with
/// ffmpeg and Deno offered at once. Once, and never again.
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

class _Fetches extends EngineFetchNotifier {
  _Fetches(this.asked);

  final List<EnginePart> asked;

  @override
  Future<bool> fetch(EnginePart part) async {
    asked.add(part);
    return true;
  }
}
