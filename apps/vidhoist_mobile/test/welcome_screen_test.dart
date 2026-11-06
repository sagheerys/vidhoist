import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/engine/welcome_screen.dart';
import 'package:vidhoist_mobile/features/engine/ytdlp_bridge.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

import 'device_matrix.dart';

/// The engine as the welcome screen sees it: each step held until the
/// test lets it go.
class _Bridge implements YtDlpBridge {
  // Made on first use, inside the test's fake clock: a completer made in
  // setUp lives on the real one, and nothing waiting on it would wake.
  late Completer<void> unpacked = Completer();
  late Completer<void> updated = Completer();
  Object? initError;
  Object? updateError;
  var inits = 0;

  @override
  Future<void> init() async {
    inits++;
    await unpacked.future;
    if (initError case final e?) throw e;
  }

  @override
  Future<({bool updated, String? version})> update({
    bool nightly = false,
  }) async {
    await updated.future;
    if (updateError case final e?) throw e;
    return (updated: true, version: '2026.10.26');
  }

  @override
  Future<String?> version() async => '2026.10.26';

  @override
  Future<BridgeRun> execute(
    String id,
    List<String> args, {
    String? stdoutFile,
  }) => throw UnimplementedError();

  @override
  Stream<({String id, String line})> get lines => const Stream.empty();

  @override
  Future<bool> cancel(String id) async => false;
}

void main() {
  late _Bridge bridge;
  late MemoryKeyValueStore store;
  var entered = 0;

  setUp(() {
    bridge = _Bridge();
    store = MemoryKeyValueStore();
    entered = 0;
  });

  Widget host({
    Brightness brightness = Brightness.light,
    Locale locale = const Locale('en'),
  }) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      initialSettingsProvider.overrideWithValue(const LiteSettings()),
      loggerProvider.overrideWithValue(
        MTLogger(filePath: '${Directory.systemTemp.path}/vh_welcome.log'),
      ),
      ytDlpBridgeProvider.overrideWithValue(bridge),
    ],
    child: MaterialApp(
      theme: mtTheme(MTVariant.lite, brightness),
      locale: locale,
      localizationsDelegates: MTLocalizations.localizationsDelegates,
      supportedLocales: MTLocalizations.supportedLocales,
      home: WelcomeScreen(onEntered: () => entered++),
    ),
  );

  MTLocalizations l10n(WidgetTester tester) =>
      tester.element(find.byType(WelcomeScreen)).mtl;

  testWidgets('it readies the engine with each step shown, then lets the '
      'person in', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump();
    final t = l10n(tester);
    expect(find.text(t.mobileWelcomeTitle), findsOneWidget);
    expect(find.text(t.mobileWelcomeUnpacking), findsOneWidget);
    final start = find.widgetWithText(FilledButton, t.mobileWelcomeStart);
    expect(tester.widget<FilledButton>(start).onPressed, isNull);

    bridge.unpacked.complete();
    await tester.pump();
    await tester.pump();
    expect(find.text(t.mobileWelcomeUpdating), findsOneWidget);
    expect(tester.widget<FilledButton>(start).onPressed, isNull);

    bridge.updated.complete();
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(start).onPressed, isNotNull);
    await tester.tap(start);
    await tester.pumpAndSettle();
    expect(entered, 1);
    expect(await store.getBool(LiteSettings.welcomedKey), isTrue);
    // A fresh install: the offer to restore a backup comes in this run, and
    // only in this one (it used to come on every launch with no server).
    final c = ProviderScope.containerOf(
      tester.element(find.byType(WelcomeScreen)),
    );
    expect(c.read(welcomedThisRunProvider), isTrue);
  });

  testWidgets('a failed update still lets the person in, and says it will '
      'try again', (tester) async {
    bridge
      ..updateError = PlatformException(code: 'offline')
      ..unpacked.complete()
      ..updated.complete();
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    expect(find.text(t.mobileWelcomeUpdateFailed), findsOneWidget);
    final start = find.widgetWithText(FilledButton, t.mobileWelcomeStart);
    expect(tester.widget<FilledButton>(start).onPressed, isNotNull);
  });

  testWidgets('an engine that will not start offers to try again', (
    tester,
  ) async {
    bridge
      ..initError = PlatformException(code: 'init_failed')
      ..unpacked.complete();
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    expect(find.text(t.mobileWelcomeFailed), findsOneWidget);

    bridge
      ..initError = null
      ..updated.complete();
    await tester.tap(find.text(t.retry));
    await tester.pumpAndSettle();
    expect(bridge.inits, 2);
    final start = find.widgetWithText(FilledButton, t.mobileWelcomeStart);
    expect(tester.widget<FilledButton>(start).onPressed, isNotNull);
  });

  test('the router sends a first run to the welcome screen, and nowhere '
      'else afterwards', () {
    expect(welcomeRedirect(welcomed: false, location: '/'), '/welcome');
    expect(welcomeRedirect(welcomed: false, location: '/settings'), '/welcome');
    expect(welcomeRedirect(welcomed: false, location: '/welcome'), isNull);
    expect(welcomeRedirect(welcomed: true, location: '/'), isNull);
    expect(welcomeRedirect(welcomed: true, location: '/welcome'), '/');
  });

  for (final brightness in Brightness.values) {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      testWidgets('**device matrix**: ${brightness.name}, '
          '${locale.languageCode}, every step', (tester) async {
        bridge
          ..updateError = PlatformException(code: 'offline')
          ..unpacked.complete()
          ..updated.complete();
        await expectNoOverflow(
          tester,
          () => host(brightness: brightness, locale: locale),
        );
      });
    }
  }
}
