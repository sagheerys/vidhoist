import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/appearance_pane.dart';
import 'package:vidhoist_desktop/features/settings/cookies_pane.dart';

import 'desktop_matrix.dart';

/// Cookies on this computer: a file the browser exported (several merged
/// into one), kept in the app's own folder for yt-dlp to read, or a
/// browser yt-dlp reads them from itself. Nothing is sent anywhere.
void main() {
  late Directory root;
  late MemoryKeyValueStore store;
  late _Folders folders;
  final l = lookupVhLocalizations(const Locale('en'));

  const youtube =
      '# Netscape HTTP Cookie File\n'
      '.youtube.com\tTRUE\t/\tTRUE\t2000000000\tSID\tabc\n';
  const instagram =
      '# Netscape HTTP Cookie File\n'
      '.instagram.com\tTRUE\t/\tTRUE\t2000000000\tsessionid\txyz\n';

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_cookies_');
    store = MemoryKeyValueStore();
    folders = _Folders();
  });
  // Windows can hold the new cookies file a moment longer (a scanner
  // reading it): the temporary folder goes when it lets go.
  tearDown(() => _remove(root));

  String target() => '${root.path}\\cookies.txt';

  Widget app({Brightness brightness = Brightness.light}) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      desktopFoldersProvider.overrideWithValue(folders),
      cookiesFileTargetProvider.overrideWithValue(target()),
    ],
    child: MaterialApp(
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      theme: vhDesktopTheme(VhVariant.desktop, brightness),
      home: const Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(VhSpace.lg),
          child: CookiesPane(),
        ),
      ),
    ),
  );

  testWidgets('files chosen together are merged into the one yt-dlp reads', (
    tester,
  ) async {
    folders.files = [
      ('youtube.txt', utf8.encode(youtube)),
      ('instagram.txt', utf8.encode(instagram)),
    ];
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopCookiesChoose));
    // The file is written, then the choice saved: under the full suite's
    // load that took longer than a fixed wait (2026-11-07), so it waits for
    // the choice itself.
    await settle(
      tester,
      until: () async =>
          File(target()).existsSync() &&
          await store.getString(EngineOptionsNotifier.cookiesFileKey) ==
              target(),
    );
    final kept = File(target()).readAsStringSync();
    expect(kept, contains('.youtube.com'));
    expect(kept, contains('.instagram.com'));
    expect(
      await store.getString(EngineOptionsNotifier.cookiesFileKey),
      target(),
    );
  });

  testWidgets('a file that is not a cookies file is refused', (tester) async {
    folders.files = [('notes.txt', utf8.encode('just some notes'))];
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopCookiesChoose));
    await settle(tester);
    expect(find.text(l.cookiesNotNetscape), findsOneWidget);
    expect(File(target()).existsSync(), isFalse);
  });

  testWidgets('removing deletes the kept file', (tester) async {
    File(target()).writeAsStringSync(youtube);
    await store.setString(EngineOptionsNotifier.cookiesFileKey, target());
    await tester.pumpWidget(app());
    // The sites are read from the file first; it is open until then.
    await settle(tester);
    await tester.tap(find.text(l.desktopCookiesRemove));
    await settle(tester);
    expect(File(target()).existsSync(), isFalse);
    expect(await store.getString(EngineOptionsNotifier.cookiesFileKey), '');
  });

  testWidgets('the pane warns that an account can be restricted', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text(l.accountsBanRisk), findsOneWidget);
  });

  testWidgets('a browser is chosen, and none again', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DesktopSegment, 'Firefox'));
    await tester.pumpAndSettle();
    expect(
      await store.getString(EngineOptionsNotifier.cookiesBrowserKey),
      'firefox',
    );
    await tester.tap(find.widgetWithText(DesktopSegment, l.desktopCookiesNone));
    await tester.pumpAndSettle();
    expect(await store.getString(EngineOptionsNotifier.cookiesBrowserKey), '');
  });

  for (final brightness in Brightness.values) {
    testWidgets('fits at 960 and 1440, both languages, ${brightness.name}', (
      tester,
    ) async {
      await expectNoOverflow(
        tester,
        () => app(brightness: brightness),
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
    });
  }
}

class _Folders extends NoFolders {
  List<(String, List<int>)> files = const [];

  @override
  Future<List<(String, List<int>)>> openFiles({
    required List<String> extensions,
  }) async => files;
}

/// Lets the pane's real file work finish: a widget test's clock does not
/// wait for the disk.
Future<void> settle(
  WidgetTester tester, {
  Future<bool> Function()? until,
}) async {
  // Each step on the disk is a turn of the real loop, then a pump; with
  // [until], as many as it takes, up to ten seconds (a flushed write under
  // the full suite's load has taken more than two).
  for (var i = 0; i < (until == null ? 10 : 500); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
    if (until != null && i >= 9 && await until()) break;
  }
  await tester.pumpAndSettle();
}

/// Deletes [dir], waiting on the real clock (a widget test's own clock does
/// not move); one Windows still holds is left in the temp folder rather
/// than failing a test that has passed.
Future<void> _remove(Directory dir) async {
  for (var tries = 0; tries < 20; tries++) {
    try {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      return;
    } on FileSystemException {
      sleep(const Duration(milliseconds: 50));
    }
  }
}
