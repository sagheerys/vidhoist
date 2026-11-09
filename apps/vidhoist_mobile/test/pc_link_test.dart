import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/add_flow.dart';
import 'package:vidhoist_mobile/features/home/link_preview_view.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_scan.dart';
import 'package:vidhoist_mobile/features/pc/pc_screen.dart';
import 'package:vidhoist_mobile/features/pc/pc_settings_fields.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

import 'device_matrix.dart';

const _pairing = PcPairing(
  host: '192.168.1.24',
  port: PcLink.defaultPort,
  fingerprint:
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
  deviceId: 'dev1',
  secret: 'the-secret',
  name: 'HOME-PC',
);

class FakeApi implements PcLinkApi {
  bool reachable = true;
  final submitted = <(String, String)>[];
  final cancelled = <String>[];
  List<PcTask> live = const [
    PcTask(
      id: 't1',
      url: 'https://youtu.be/x',
      title: 'Designing Data-Intensive Applications: full course',
      phase: 'downloading',
      progress: 38,
      speed: 11.2e6,
      eta: 160,
    ),
  ];

  void _check() {
    if (!reachable) throw const PcLinkException(PcLinkFailure.unreachable);
  }

  @override
  Future<PcStatus> status() async {
    _check();
    return const PcStatus(name: 'HOME-PC', version: '1.0.0', active: 1);
  }

  @override
  Future<List<PcTask>> tasks() async {
    _check();
    return live;
  }

  @override
  Future<PcTask> submit(String url, String quality) async {
    _check();
    submitted.add((url, quality));
    return PcTask(id: 't9', url: url, phase: 'queued', quality: quality);
  }

  @override
  Future<bool> cancel(String id) async {
    cancelled.add(id);
    return true;
  }

  @override
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  }) async {
    _check();
    return PcLibraryPage(
      items: [
        PcItem(
          id: 'i1',
          title: 'Rust for TypeScript devs',
          duration: const Duration(minutes: 44),
          sizeBytes: 890000000,
          added: DateTime(2026, 11, 9),
        ),
        const PcItem(
          id: 'i2',
          title: 'بودكاست: تاريخ الخط العربي',
          isAudio: true,
          sizeBytes: 58000000,
        ),
      ],
      total: 312,
    );
  }

  @override
  Future<Uint8List?> cover(String id) async => null;

  @override
  void close() {}
}

List<Override> _overrides({
  required MemoryKeyValueStore store,
  required MemorySecretStore secrets,
  PcPairing? pairing,
  FakeApi? api,
  PcPairer? pairer,
  PcScanner? scanner,
  PcOfferPairer? offerPairer,
  LocalDownloadEngine? engine,
}) => [
  keyValueStoreProvider.overrideWithValue(store),
  secretStoreProvider.overrideWithValue(secrets),
  prefsMutexProvider.overrideWithValue(PrefsMutex()),
  initialSettingsProvider.overrideWithValue(const PhoneSettings()),
  loggerProvider.overrideWithValue(
    VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc_test.log'),
  ),
  initialPcPairingProvider.overrideWithValue(pairing),
  if (api != null)
    pcClientProvider.overrideWith(
      (ref) => ref.watch(pcPairingProvider) == null ? null : api,
    ),
  if (pairer != null) pcPairerProvider.overrideWithValue(pairer),
  if (scanner != null) pcScannerProvider.overrideWithValue(scanner),
  if (offerPairer != null) pcOfferPairerProvider.overrideWithValue(offerPairer),
  pcPhoneNameProvider.overrideWithValue(() async => 'Galaxy'),
  downloadEngineProvider.overrideWithValue(engine),
  linkPreviewResolverProvider.overrideWithValue(
    ClipPreviewResolver(httpGet: (_) async => '{}'),
  ),
];

Widget _app(
  List<Override> overrides,
  Widget child, {
  Locale locale = const Locale('en'),
  Brightness brightness = Brightness.light,
}) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    theme: vhTheme(VhVariant.phone, brightness),
    locale: locale,
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    home: child,
  ),
);

void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late MemoryKeyValueStore store;
  late MemorySecretStore secrets;

  setUp(() {
    store = MemoryKeyValueStore();
    secrets = MemorySecretStore();
  });

  group('nothing changes for a phone that never paired', () {
    test('three tabs unpaired, the computer before settings once paired', () {
      expect(shellTabs(paired: false), [
        ShellBranch.library,
        ShellBranch.playlists,
        ShellBranch.settings,
      ]);
      expect(shellTabs(paired: true), [
        ShellBranch.library,
        ShellBranch.playlists,
        ShellBranch.pc,
        ShellBranch.settings,
      ]);
    });

    test('no pairing is read when none was saved', () async {
      expect(await loadPcPairing(store, secrets), isNull);
    });
  });

  test(
    'a pairing survives a restart, its secret only in the encrypted store',
    () async {
      final container = ProviderContainer(
        overrides: _overrides(store: store, secrets: secrets),
      );
      addTearDown(container.dispose);
      await container.read(pcPairingProvider.notifier).save(_pairing);
      expect(
        await store.getString(pcPairingKey),
        isNot(contains('the-secret')),
      );
      expect(await secrets.read(pcSecretKey), 'the-secret');
      final back = await loadPcPairing(store, secrets);
      expect(back?.toJson(), _pairing.toJson());

      await container.read(pcPairingProvider.notifier).forget();
      expect(container.read(pcPairingProvider), isNull);
      expect(await loadPcPairing(store, secrets), isNull);
      expect(await secrets.read(pcSecretKey), isNull);
    },
  );

  test('a backup leaves the pairing out', () async {
    final container = ProviderContainer(
      overrides: _overrides(store: store, secrets: secrets),
    );
    addTearDown(container.dispose);
    await container.read(pcPairingProvider.notifier).save(_pairing);
    await store.setString(pcCacheKey, '{"library":{}}');
    await store.setBool(pcSendToPcKey, true);
    final backup = await container.read(backupServiceProvider).exportToString();
    for (final key in pcDeviceOnlyKeys) {
      expect(backup, isNot(contains(key)), reason: key);
    }
    expect(backup, isNot(contains('the-secret')));
  });

  test('addresses read as the computer shows them', () {
    expect(parsePcAddress('192.168.1.24:47321'), ('192.168.1.24', 47321));
    expect(parsePcAddress(' 192.168.1.24 '), (
      '192.168.1.24',
      PcLink.defaultPort,
    ));
    expect(parsePcAddress('https://10.0.0.5:8000/'), ('10.0.0.5', 8000));
    expect(parsePcAddress('home-pc.local:47321'), ('home-pc.local', 47321));
    expect(parsePcAddress('999.1.1.1'), isNull);
    expect(parsePcAddress('1.2.3.4:99999'), isNull);
    expect(parsePcAddress('not an address!'), isNull);
  });

  group('pairing from Settings › Computer', () {
    testWidgets(
      'the four digits show while the computer decides, then it is paired',
      (tester) async {
        final allow = Completer<void>();
        Future<PcPairing> pairer({
          required String host,
          required int port,
          required String code,
          required String phoneName,
          required void Function(String check) onCheck,
        }) async {
          expect((host, port, code), ('192.168.1.24', 47321, '123456'));
          onCheck('4821');
          await allow.future;
          return _pairing;
        }

        await tester.pumpWidget(
          _app(
            _overrides(store: store, secrets: secrets, pairer: pairer),
            const Scaffold(
              body: SingleChildScrollView(child: PcSettingsFields()),
            ),
          ),
        );
        // No port typed: the number pad has no colon, and the default is
        // the computer's own.
        await tester.enterText(find.byType(TextField).at(0), '192.168.1.24');
        await tester.enterText(find.byType(TextField).at(2), '123456');
        await tester.tap(find.text(l.pcPairButton));
        await tester.pump();
        expect(find.text('4 8 2 1'), findsOneWidget);
        expect(find.text(l.pcPairCheck('4821')), findsOneWidget);
        allow.complete();
        await tester.pumpAndSettle();
        expect(find.text('HOME-PC'), findsOneWidget);
        expect(find.text(l.pcLinkRevoke), findsOneWidget);
        expect(await secrets.read(pcSecretKey), 'the-secret');
      },
    );

    testWidgets('a wrong address is caught before anything is sent', (
      tester,
    ) async {
      var called = false;
      Future<PcPairing> pairer({
        required String host,
        required int port,
        required String code,
        required String phoneName,
        required void Function(String check) onCheck,
      }) async {
        called = true;
        return _pairing;
      }

      await tester.pumpWidget(
        _app(
          _overrides(store: store, secrets: secrets, pairer: pairer),
          const Scaffold(
            body: SingleChildScrollView(child: PcSettingsFields()),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(0), 'nowhere!');
      await tester.enterText(find.byType(TextField).at(2), '123456');
      await tester.tap(find.text(l.pcPairButton));
      await tester.pump();
      expect(find.text(l.pcBadAddress), findsOneWidget);
      expect(called, isFalse);
    });

    testWidgets('**the guard**: a port other than the default has a field '
        'of its own, typed on the number pad', (tester) async {
      int? asked;
      Future<PcPairing> pairer({
        required String host,
        required int port,
        required String code,
        required String phoneName,
        required void Function(String check) onCheck,
      }) async {
        asked = port;
        throw const PcLinkException(PcLinkFailure.unreachable);
      }

      await tester.pumpWidget(
        _app(
          _overrides(store: store, secrets: secrets, pairer: pairer),
          const Scaffold(
            body: SingleChildScrollView(child: PcSettingsFields()),
          ),
        ),
      );
      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(
        fields.where((f) => f.keyboardType.index == TextInputType.number.index),
        hasLength(3),
        reason: 'no field needs a key the number pad lacks',
      );
      expect(find.text('192.168.1.24:${PcLink.defaultPort}'), findsNothing);
      await tester.enterText(find.byType(TextField).at(0), '192.168.1.24');
      await tester.enterText(find.byType(TextField).at(1), '50000');
      await tester.enterText(find.byType(TextField).at(2), '123456');
      await tester.tap(find.text(l.pcPairButton));
      await tester.pumpAndSettle();
      expect(asked, 50000);
    });

    group('by the QR code', () {
      final offer = PcPairOffer(
        hosts: const ['192.168.1.24', '100.101.102.103'],
        port: PcLink.defaultPort,
        code: '123456',
        fingerprint: _pairing.fingerprint,
      );

      Future<void> open(
        WidgetTester tester, {
        required String? scanned,
        required PcOfferPairer offerPairer,
      }) async {
        await tester.pumpWidget(
          _app(
            _overrides(
              store: store,
              secrets: secrets,
              scanner: (_) async => scanned,
              offerPairer: offerPairer,
            ),
            const Scaffold(
              body: SingleChildScrollView(child: PcSettingsFields()),
            ),
          ),
        );
        await tester.tap(find.text(l.pcScanButton));
        await tester.pumpAndSettle();
      }

      testWidgets('a scan pairs, nothing typed', (tester) async {
        PcPairOffer? used;
        await open(
          tester,
          scanned: offer.toUri(),
          offerPairer:
              ({required offer, required phoneName, required onCheck}) async {
                used = offer;
                return _pairing;
              },
        );
        expect(used?.hosts, offer.hosts);
        expect(used?.fingerprint, offer.fingerprint);
        expect(find.text('HOME-PC'), findsOneWidget);
        expect(await secrets.read(pcSecretKey), 'the-secret');
      });

      testWidgets('**the guard**: a code that is not an offer reaches '
          'nothing', (tester) async {
        var called = false;
        await open(
          tester,
          scanned: 'https://example.com/promo',
          offerPairer:
              ({required offer, required phoneName, required onCheck}) async {
                called = true;
                return _pairing;
              },
        );
        expect(find.text(l.pcBadQr), findsOneWidget);
        expect(called, isFalse);
        expect(await loadPcPairing(store, secrets), isNull);
      });

      testWidgets('backing out of the camera changes nothing', (tester) async {
        var called = false;
        await open(
          tester,
          scanned: null,
          offerPairer:
              ({required offer, required phoneName, required onCheck}) async {
                called = true;
                return _pairing;
              },
        );
        expect(called, isFalse);
        expect(find.text(l.pcBadQr), findsNothing);
        expect(find.text(l.pcScanButton), findsOneWidget);
      });
    });

    testWidgets('a refusal on the computer says so', (tester) async {
      Future<PcPairing> pairer({
        required String host,
        required int port,
        required String code,
        required String phoneName,
        required void Function(String check) onCheck,
      }) async => throw const PcLinkException(PcLinkFailure.pairingDenied);

      await tester.pumpWidget(
        _app(
          _overrides(store: store, secrets: secrets, pairer: pairer),
          const Scaffold(
            body: SingleChildScrollView(child: PcSettingsFields()),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(0), '192.168.1.24');
      await tester.enterText(find.byType(TextField).at(2), '123456');
      await tester.tap(find.text(l.pcPairButton));
      await tester.pumpAndSettle();
      expect(find.text(l.pcErrDenied), findsOneWidget);
      expect(await loadPcPairing(store, secrets), isNull);
    });

    testWidgets('unpairing takes the computer away', (tester) async {
      await tester.pumpWidget(
        _app(
          _overrides(store: store, secrets: secrets, pairing: _pairing),
          const Scaffold(
            body: SingleChildScrollView(child: PcSettingsFields()),
          ),
        ),
      );
      await tester.tap(find.text(l.pcLinkRevoke));
      await tester.pumpAndSettle();
      expect(find.text(l.pcPairButton), findsOneWidget);
    });
  });

  group('the Computer page', () {
    testWidgets('shows the computer, what it downloads, and its library', (
      tester,
    ) async {
      final api = FakeApi();
      await tester.pumpWidget(
        _app(
          _overrides(
            store: store,
            secrets: secrets,
            pairing: _pairing,
            api: api,
          ),
          const PcScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('HOME-PC'), findsOneWidget);
      expect(find.text(l.pcConnected), findsOneWidget);
      expect(find.text('${l.pcNow} · 1'), findsOneWidget);
      expect(find.text('38%'), findsOneWidget);
      expect(find.text('${l.pcLibrary} · 312'), findsOneWidget);
      expect(find.text('Rust for TypeScript devs'), findsOneWidget);
      // The page asks again on its own while something downloads.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('**the guard**: a clip tapped says watching comes later, '
        'rather than doing nothing', (tester) async {
      await tester.pumpWidget(
        _app(
          _overrides(
            store: store,
            secrets: secrets,
            pairing: _pairing,
            api: FakeApi(),
          ),
          const Scaffold(body: PcScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rust for TypeScript devs'));
      await tester.pump();
      expect(find.text(l.pcWatchLater), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('away, it says so and keeps what it saw last', (tester) async {
      final api = FakeApi();
      await tester.pumpWidget(
        _app(
          _overrides(
            store: store,
            secrets: secrets,
            pairing: _pairing,
            api: api,
          ),
          const PcScreen(),
        ),
      );
      await tester.pumpAndSettle();
      api.reachable = false;
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        _app(
          _overrides(
            store: store,
            secrets: secrets,
            pairing: _pairing,
            api: api,
          ),
          const PcScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(l.pcOffline), findsOneWidget);
      expect(find.text(l.pcOfflineMessage), findsOneWidget);
      expect(
        find.text('Rust for TypeScript devs'),
        findsOneWidget,
        reason: 'the cache',
      );
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('a download there can be stopped from here', (tester) async {
      final api = FakeApi();
      await tester.pumpWidget(
        _app(
          _overrides(
            store: store,
            secrets: secrets,
            pairing: _pairing,
            api: api,
          ),
          const PcScreen(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find
            .byWidgetPredicate((w) => w is VhIcon && w.icon == VhIcons.close)
            .first,
      );
      await tester.pumpAndSettle();
      expect(api.cancelled, ['t1']);
      await tester.pumpWidget(const SizedBox());
    });

    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets('holds on every device, ${locale.languageCode}', (
        tester,
      ) async {
        final api = FakeApi();
        await expectNoOverflow(
          tester,
          () => _app(
            _overrides(
              store: store,
              secrets: secrets,
              pairing: _pairing,
              api: api,
            ),
            const PcScreen(),
            locale: locale,
          ),
        );
        await tester.pumpWidget(const SizedBox());
      });
    }

    testWidgets('the pairing form holds on every device, ar', (tester) async {
      await expectNoOverflow(
        tester,
        () => _app(
          _overrides(store: store, secrets: secrets),
          const Scaffold(
            body: SingleChildScrollView(child: PcSettingsFields()),
          ),
          locale: const Locale('ar'),
        ),
      );
    });
  });

  group('the add sheet', () {
    late _Engine engine;

    Widget host(FakeApi api, {PcPairing? pairing = _pairing}) {
      engine = _Engine();
      return ProviderScope(
        overrides: _overrides(
          store: store,
          secrets: secrets,
          pairing: pairing,
          api: api,
          engine: engine,
        ),
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
                      onPressed: () => openAddSheet(
                        context,
                        ref,
                        initialUrl:
                            'https://www.youtube.com/watch?v=jNQXAC9IVRw',
                      ),
                      child: const Text('open'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> open(
      WidgetTester tester,
      FakeApi api, {
      PcPairing? pairing = _pairing,
    }) async {
      tester.view.physicalSize = const Size(411, 914);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(api, pairing: pairing));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('unpaired: no choice, the phone downloads as always', (
      tester,
    ) async {
      await open(tester, FakeApi(), pairing: null);
      expect(find.text(l.storageLocation), findsNothing);
      expect(find.text(l.startDownload), findsOneWidget);
    });

    testWidgets('paired but away: no choice either', (tester) async {
      await open(tester, FakeApi()..reachable = false);
      expect(find.text(l.storageLocation), findsNothing);
    });

    testWidgets('paired and there: the computer takes the link', (
      tester,
    ) async {
      final api = FakeApi();
      await open(tester, api);
      expect(find.text(l.storageLocation), findsOneWidget);
      await tester.tap(find.text('HOME-PC'));
      await tester.pumpAndSettle();
      expect(find.text(l.pcSendToPc), findsOneWidget);
      await tester.tap(find.text('Up to 720p'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.pcSendToPc));
      await tester.pumpAndSettle();
      expect(api.submitted, [
        ('https://www.youtube.com/watch?v=jNQXAC9IVRw', '720'),
      ]);
      expect(engine.qualities, isEmpty, reason: 'not downloaded on the phone');
      expect(find.text(l.pcSent('HOME-PC')), findsOneWidget);
      expect(await store.getBool(pcSendToPcKey), isTrue, reason: 'remembered');
    });

    testWidgets('choosing the phone downloads here', (tester) async {
      final api = FakeApi();
      await open(tester, api);
      await tester.tap(find.text(l.pcDestPhone));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.startDownload));
      await tester.pumpAndSettle();
      expect(api.submitted, isEmpty);
      expect(engine.qualities, hasLength(1));
    });
  });
}

class _Engine implements LocalDownloadEngine {
  final qualities = <Quality>[];

  @override
  DownloadTask submit(
    String url,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
  }) {
    qualities.add(quality);
    return DownloadTask(inputUrl: url, quality: quality, folder: folder);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
