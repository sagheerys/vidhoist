import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/backup_data.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/pc_link_data.dart';
import 'package:vidhoist_desktop/data/pc_link_host.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/phone_pane.dart';
import 'package:vidhoist_desktop/features/settings/phone_qr.dart';
import 'package:vidhoist_desktop/features/settings/simple_panes.dart';

import 'desktop_matrix.dart';

class _NoHost implements PcLinkHost {
  @override
  PcStatus status() => const PcStatus(name: 'PC', version: '');
  @override
  List<PcTask> tasks() => const [];
  @override
  PcTask? submit(String url, String quality) => null;
  @override
  bool cancel(String id) => false;
  @override
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  }) async => const PcLibraryPage(items: [], total: 0);
  @override
  Future<File?> cover(String id) async => null;
  @override
  Future<File?> file(String id) async => null;
  @override
  Future<List<Object?>> transcripts(String id) async => const [];
  @override
  Future<List<PcList>> lists() async => const [];
  @override
  Future<PcList?> list(String id) async => null;
  @override
  Future<PcDeleteOutcome> delete(String id) async => PcDeleteOutcome.missing;
}

const _addresses = [
  PcAddress(
    address: '192.168.1.24',
    adapter: 'Wi-Fi',
    kind: PcAddressKind.home,
  ),
  PcAddress(
    address: '100.101.102.103',
    adapter: 'Tailscale',
    kind: PcAddressKind.tailscale,
  ),
  PcAddress(
    address: '192.168.56.1',
    adapter: 'VirtualBox Host-Only Network',
    kind: PcAddressKind.other,
  ),
];

/// Settings › Phone: off until turned on; a code to pair; the owner
/// allowing the phone after comparing four digits; the phones listed.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  final certificate = PcCertificate.generate();
  late MemoryKeyValueStore store;
  late MemoryPcDeviceStore devices;
  late PcPairingWindow pairing;

  setUp(() async {
    store = MemoryKeyValueStore();
    devices = MemoryPcDeviceStore();
    pairing = PcPairingWindow(
      store: devices,
      fingerprint: certificate.fingerprint,
    );
    await pairing.load();
  });

  Widget app({bool on = true, Brightness brightness = Brightness.light}) {
    final session = PcLinkSession(
      server: PcLinkServer(
        certificate: certificate,
        host: _NoHost(),
        pairing: pairing,
        name: 'PC',
      ),
      pairing: pairing,
      port: PcLink.defaultPort,
    );
    return ProviderScope(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        pcLinkProvider.overrideWith((ref) async => on ? session : null),
        pcLinkAddressesProvider.overrideWith((ref) async => _addresses),
      ],
      child: MaterialApp(
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: vhDesktopTheme(VhVariant.desktop, brightness),
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(VhSpace.lg),
            child: PhonePane(),
          ),
        ),
      ),
    );
  }

  Future<void> turnOn(WidgetTester tester) async {
    await store.setBool(pcLinkEnabledKey, true);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
  }

  testWidgets('off by default: no address, no pairing', (tester) async {
    await tester.pumpWidget(app(on: false));
    await tester.pumpAndSettle();
    expect(find.text(l.pcLinkReceive), findsOneWidget);
    expect(find.text(l.pcLinkPairPhone), findsNothing);
    expect(find.text(l.pcLinkAllowDelete), findsNothing);
    expect(find.textContaining('192.168.1.24'), findsNothing);
  });

  testWidgets('turning it on is saved on this device', (tester) async {
    await tester.pumpWidget(app(on: false));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(VhSwitch));
    await tester.pumpAndSettle();
    expect(await store.getBool(pcLinkEnabledKey), isTrue);
  });

  testWidgets('deleting from the phone: off, offered with the link, saved', (
    tester,
  ) async {
    await turnOn(tester);
    expect(find.text(l.pcLinkAllowDelete), findsOneWidget);
    final line = find.ancestor(
      of: find.text(l.pcLinkAllowDelete),
      matching: find.byType(SwitchLine),
    );
    expect(tester.widget<SwitchLine>(line).value, isFalse);
    await tester.ensureVisible(line);
    await tester.tap(
      find.descendant(of: line, matching: find.byType(VhSwitch)),
    );
    await tester.pumpAndSettle();
    expect(await store.getBool(pcLinkDeleteKey), isTrue);
  });

  testWidgets('a code shows, then the owner allows the phone by its digits', (
    tester,
  ) async {
    await turnOn(tester);
    expect(find.text('192.168.1.24:${PcLink.defaultPort}'), findsOneWidget);
    await tester.tap(find.text(l.pcLinkPairPhone));
    await tester.pump();
    final code = pairing.code!;
    expect(find.text(code.split('').join(' ')), findsOneWidget);

    late Future<({PcDevice? device, String? secret, PcPairRefusal? refusal})>
    attempt;
    await tester.runAsync(() async {
      attempt = pairing.attempt(code: code, name: 'Galaxy', nonce: newSecret());
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await tester.pump();
    expect(find.text(l.pcLinkRequest('Galaxy')), findsOneWidget);
    final check = pairingCheck(
      fingerprint: certificate.fingerprint,
      code: code,
      nonce: 'x',
    );
    expect(check, hasLength(4));
    await tester.tap(find.text(l.pcLinkAllow));
    await tester.runAsync(() async {
      final result = await attempt;
      expect(result.device?.name, 'Galaxy');
    });
    await tester.pumpAndSettle();
    expect(find.text('Galaxy'), findsOneWidget);
    expect(find.text(l.pcLinkRevoke), findsOneWidget);
  });

  testWidgets('**the guard**: the home address first, Tailscale named, '
      'the other adapters folded away', (tester) async {
    await turnOn(tester);
    expect(find.text('192.168.1.24:${PcLink.defaultPort}'), findsOneWidget);
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text(l.pcLinkAddressTailscale), findsOneWidget);
    expect(find.text('100.101.102.103:${PcLink.defaultPort}'), findsOneWidget);
    expect(find.textContaining('192.168.56.1'), findsNothing);
    await tester.tap(find.text(l.pcLinkOtherAddresses(1)));
    await tester.pumpAndSettle();
    expect(find.text('192.168.56.1:${PcLink.defaultPort}'), findsOneWidget);
  });

  test('**the guard**: the settings list counts a phone paired after it '
      'was read', () async {
    final session = PcLinkSession(
      server: PcLinkServer(
        certificate: certificate,
        host: _NoHost(),
        pairing: pairing,
        name: 'PC',
      ),
      pairing: pairing,
      port: PcLink.defaultPort,
    );
    final container = ProviderContainer(
      overrides: [pcLinkProvider.overrideWith((ref) async => session)],
    );
    addTearDown(container.dispose);
    final seen = <int>[];
    container.listen(
      pcLinkDevicesProvider,
      (_, next) => next.whenData((d) => seen.add(d.length)),
      fireImmediately: true,
    );
    await pumpEventQueue();
    pairing.open();
    // Listening before the attempt: the request is not replayed.
    final request = pairing.requests.first;
    final result = pairing.attempt(
      code: pairing.code!,
      name: 'Galaxy',
      nonce: newSecret(),
    );
    (await request).allow();
    expect((await result).device?.name, 'Galaxy');
    await pumpEventQueue();
    expect(seen.last, 1);
    expect(seen.first, 0);
  });

  testWidgets('**the guard**: the QR code carries every address, home '
      'first, the code and the fingerprint of this computer', (tester) async {
    await turnOn(tester);
    await tester.tap(find.text(l.pcLinkPairPhone));
    await tester.pump();
    final qr = tester.widget<PhoneQr>(find.byType(PhoneQr));
    final offer = PcPairOffer.parse(qr.data)!;
    expect(offer.hosts, ['192.168.1.24', '100.101.102.103', '192.168.56.1']);
    expect(offer.port, PcLink.defaultPort);
    expect(offer.code, pairing.code);
    expect(offer.fingerprint, certificate.fingerprint);
    // The code to type stays beside it.
    expect(find.text(pairing.code!.split('').join(' ')), findsOneWidget);
  });

  testWidgets('unpairing forgets the phone', (tester) async {
    devices.devices = [
      PcDevice(
        id: 'd1',
        name: 'Galaxy',
        secretHash: secretHash('s'),
        pairedAt: DateTime(2026),
      ),
    ];
    await pairing.load();
    await turnOn(tester);
    await tester.tap(find.text(l.pcLinkRevoke));
    await tester.pumpAndSettle();
    expect(devices.devices, isEmpty);
    expect(find.text(l.pcLinkNoDevices), findsOneWidget);
  });

  testWidgets('leaving the page shuts the code', (tester) async {
    await turnOn(tester);
    await tester.tap(find.text(l.pcLinkPairPhone));
    await tester.pump();
    expect(pairing.isOpen, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(pairing.isOpen, isFalse);
  });

  test('**the guard**: the status a phone reads carries the addresses '
      'of this computer, for its choice of route', () {
    final container = ProviderContainer(
      overrides: [
        downloadEngineProvider.overrideWithValue(null),
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
      ],
    );
    addTearDown(container.dispose);
    final host = container.read(
      Provider(
        (ref) => DesktopPcHost(
          ref,
          name: 'PC',
          version: '1',
          addresses: () => _addresses,
        ),
      ),
    );
    expect(host.status().addresses, _addresses);
  });

  test('a backup leaves the link out', () {
    expect(
      pcLinkDeviceOnlyKeys,
      containsAll([pcLinkEnabledKey, pcLinkDevicesKey, pcLinkDeleteKey]),
    );
    expect(desktopBackupDeviceOnlyKeys, containsAll(pcLinkDeviceOnlyKeys));
  });

  for (final brightness in Brightness.values) {
    testWidgets('fits at 960 and 1440, both languages, ${brightness.name}', (
      tester,
    ) async {
      await store.setBool(pcLinkEnabledKey, true);
      devices.devices = [
        PcDevice(
          id: 'd1',
          name: 'Galaxy S23 Ultra of the family',
          secretHash: 'h',
          pairedAt: DateTime(2026),
        ),
      ];
      await pairing.load();
      pairing.open();
      await expectNoOverflow(
        tester,
        () => app(brightness: brightness),
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
      pairing.close();
    });
  }
}
