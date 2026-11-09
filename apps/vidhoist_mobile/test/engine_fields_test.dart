import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/engine/ytdlp_bridge.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/settings/widgets/engine_fields.dart';

import 'device_matrix.dart';

class _Bridge implements YtDlpBridge {
  var updates = 0;
  Object? updateError;

  @override
  Future<void> init() async {}

  @override
  Future<String?> version() async => '2026.10.26';

  @override
  Future<({bool updated, String? version})> update({
    bool nightly = false,
  }) async {
    updates++;
    if (updateError case final e?) throw e;
    return (updated: true, version: '2026.11.01');
  }

  var repairs = 0;
  Object? repairError;

  @override
  Future<({bool updated, String? version})> repair() async {
    repairs++;
    if (repairError case final e?) throw e;
    return (updated: true, version: '2026.11.05');
  }

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

/// The engine's settings page: yt-dlp's version, an update on demand
/// (`docs/ENGINE.md` finding 12), and IPv4.
/// An engine with a download under way, which a repair must wait for.
class _BusyEngine extends LocalDownloadEngine {
  _BusyEngine() : super(backend: FakeBackend(), folderFor: (_) => '');

  @override
  bool get hasActiveWork => true;
}

void main() {
  late _Bridge bridge;
  late MemoryKeyValueStore store;
  final logger = VhLogger(
    filePath: '${Directory.systemTemp.path}/vh_engine_fields.log',
  );

  setUp(() {
    bridge = _Bridge();
    store = MemoryKeyValueStore();
  });

  Widget host({
    Brightness brightness = Brightness.light,
    Locale locale = const Locale('en'),
    bool downloading = false,
  }) => ProviderScope(
    overrides: [
      if (downloading) downloadEngineProvider.overrideWithValue(_BusyEngine()),
      keyValueStoreProvider.overrideWithValue(store),
      initialSettingsProvider.overrideWithValue(const PhoneSettings()),
      loggerProvider.overrideWithValue(logger),
      ytDlpBridgeProvider.overrideWithValue(bridge),
    ],
    child: MaterialApp(
      theme: vhTheme(VhVariant.phone, brightness),
      locale: locale,
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      home: const Scaffold(body: SingleChildScrollView(child: EngineFields())),
    ),
  );

  VhLocalizations l10n(WidgetTester tester) =>
      tester.element(find.byType(EngineFields)).vhl;

  testWidgets('the update button updates, and the version follows', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    expect(find.text(t.mobileEngineVersionUnknown), findsOneWidget);

    await tester.tap(find.text(t.mobileEngineUpdate));
    await tester.pumpAndSettle();
    expect(bridge.updates, 1);
    expect(find.text('2026.11.01'), findsOneWidget);
    expect(find.text(t.mobileEngineUpToDate), findsOneWidget);
  });

  testWidgets('a failed update says so', (tester) async {
    bridge.updateError = PlatformException(code: 'offline');
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    await tester.tap(find.text(t.mobileEngineUpdate));
    await tester.pumpAndSettle();
    expect(find.text(t.mobileEngineUpdateFailed), findsOneWidget);
  });

  testWidgets('the repair puts back a clean yt-dlp and names it', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    await tester.ensureVisible(find.text(t.engineRepair));
    await tester.tap(find.text(t.engineRepair));
    await tester.pumpAndSettle();
    expect(bridge.repairs, 1);
    expect(find.text(t.engineRepaired('2026.11.05')), findsOneWidget);
    expect(find.text('2026.11.05'), findsOneWidget);
  });

  testWidgets('a repair that could not fetch says it is partly done', (
    tester,
  ) async {
    bridge.repairError = PlatformException(code: 'offline');
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    await tester.ensureVisible(find.text(t.engineRepair));
    await tester.tap(find.text(t.engineRepair));
    await tester.pumpAndSettle();
    expect(find.text(t.engineRepairPartly), findsOneWidget);
  });

  testWidgets('no repair while something downloads: it would replace the '
      'yt-dlp that download reads', (tester) async {
    await tester.pumpWidget(host(downloading: true));
    await tester.pumpAndSettle();
    final t = l10n(tester);
    await tester.ensureVisible(find.text(t.engineRepair));
    await tester.tap(find.text(t.engineRepair));
    await tester.pumpAndSettle();
    expect(bridge.repairs, 0);
    expect(find.text(t.engineRepairBusy), findsOneWidget);
  });

  testWidgets('IPv4 is on, and turns off', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    final t = l10n(tester);
    final ipv4 = find.widgetWithText(SwitchListTile, t.mobileEngineIpv4);
    expect(tester.widget<SwitchListTile>(ipv4).value, isTrue);
    await tester.tap(ipv4);
    await tester.pumpAndSettle();
    expect(await store.getBool('engine_force_ipv4'), isFalse);
  });

  for (final brightness in Brightness.values) {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      testWidgets('**device matrix**: ${brightness.name}, '
          '${locale.languageCode}', (tester) async {
        await expectNoOverflow(
          tester,
          () => host(brightness: brightness, locale: locale),
        );
      });
    }
  }
}
