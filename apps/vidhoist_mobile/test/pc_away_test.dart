import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/pc/pc_follow.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_outbox.dart';
import 'package:vidhoist_mobile/features/pc/pc_outbox_section.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_settings_fields.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

import 'pc_link_test.dart' show FakeApi;

const _pairing = PcPairing(
  host: '192.168.1.24',
  port: PcLink.defaultPort,
  fingerprint:
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
  deviceId: 'dev1',
  secret: 'the-secret',
  name: 'HOME-PC',
);

/// Batch C of the link on the phone: the computer found again at a new
/// address, links that wait while it is away, and finding it to pair.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late MemoryKeyValueStore store;
  late MemorySecretStore secrets;

  setUp(() async {
    store = MemoryKeyValueStore();
    secrets = MemorySecretStore();
    await secrets.write(pcSecretKey, _pairing.secret);
  });

  /// The computer answers only at [at]; the network says it is at [found].
  List<Override> overrides({
    PcPairing? pairing = _pairing,
    String at = '192.168.1.24',
    PcFound? found,
    List<PcFound> pairable = const [],
    void Function()? asked,
    FakeApi? api,
  }) => [
    keyValueStoreProvider.overrideWithValue(store),
    secretStoreProvider.overrideWithValue(secrets),
    prefsMutexProvider.overrideWithValue(PrefsMutex()),
    initialSettingsProvider.overrideWithValue(const PhoneSettings()),
    loggerProvider.overrideWithValue(
      VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc_away.log'),
    ),
    initialPcPairingProvider.overrideWithValue(pairing),
    pcClientProvider.overrideWith((ref) {
      final p = ref.watch(pcPairingProvider);
      if (p == null) return null;
      return (api ?? FakeApi())..reachable = p.host == at;
    }),
    pcFinderProvider.overrideWithValue((_) async {
      asked?.call();
      return found;
    }),
    pcPairableFinderProvider.overrideWithValue(() async => pairable),
  ];

  group('a new address from the router', () {
    test('**the guard**: found on the home network, the link follows it, '
        'no new pairing', () async {
      final container = ProviderContainer(
        overrides: overrides(
          at: '192.168.1.77',
          found: const PcFound(host: '192.168.1.77', port: 47321),
        ),
      );
      addTearDown(container.dispose);
      expect(await container.read(pcViewProvider.notifier).probe(), isTrue);
      expect(container.read(pcPairingProvider)?.host, '192.168.1.77');
      expect(
        (await loadPcPairing(store, secrets))?.host,
        '192.168.1.77',
        reason: 'kept for the next start',
      );
    });

    test(
      '**the guard**: the route chosen is never switched: Tailscale is '
      'not left, and an answer from off the home network is not taken',
      () async {
        var asked = 0;
        final onTailscale = ProviderContainer(
          overrides: overrides(
            pairing: _pairing.copyWith(host: '100.101.102.103'),
            found: const PcFound(host: '192.168.1.77', port: 47321),
            asked: () => asked++,
          ),
        );
        addTearDown(onTailscale.dispose);
        expect(
          await onTailscale.read(pcViewProvider.notifier).probe(),
          isFalse,
        );
        expect(asked, 0, reason: 'the network is not even asked');
        expect(onTailscale.read(pcPairingProvider)?.host, '100.101.102.103');

        final elsewhere = ProviderContainer(
          overrides: overrides(
            at: '100.101.102.103',
            found: const PcFound(host: '100.101.102.103', port: 47321),
          ),
        );
        addTearDown(elsewhere.dispose);
        expect(await elsewhere.read(pcViewProvider.notifier).probe(), isFalse);
        expect(elsewhere.read(pcPairingProvider)?.host, '192.168.1.24');
      },
    );

    test(
      'a computer that is off is asked after at most twice a minute',
      () async {
        var asked = 0;
        final container = ProviderContainer(
          overrides: overrides(at: 'nowhere', asked: () => asked++),
        );
        addTearDown(container.dispose);
        final view = container.read(pcViewProvider.notifier);
        expect(await view.probe(), isFalse);
        expect(await view.probe(), isFalse);
        await view.refresh();
        expect(asked, 1);
      },
    );
  });

  group('links sent while it is away', () {
    test('**the guard**: sent in order when it answers; one it refuses is '
        'kept, marked, and not sent again', () async {
      final api = FakeApi()..refuse = {'https://x.test/b'};
      final container = ProviderContainer(
        overrides: overrides(at: 'nowhere', api: api),
      );
      addTearDown(container.dispose);
      final outbox = container.read(pcOutboxProvider.notifier);
      for (final url in ['a', 'b', 'c']) {
        await outbox.add('https://x.test/$url', 'best');
      }
      // Away: nothing goes, nothing is lost.
      expect(await container.read(pcViewProvider.notifier).probe(), isFalse);
      expect(container.read(pcOutboxProvider), hasLength(3));

      final back = FakeApi()..refuse = {'https://x.test/b'};
      expect(await outbox.send(back), hasLength(2));
      expect(back.submitted.map((s) => s.$1), [
        'https://x.test/a',
        'https://x.test/c',
      ]);
      final left = container.read(pcOutboxProvider).single;
      expect(left.url, 'https://x.test/b');
      expect(left.refused, isTrue);
      expect(await outbox.send(back), isEmpty);
      expect(back.submitted, hasLength(2));
    });

    test(
      'they go by themselves once it answers, the page never opened',
      () async {
        final api = FakeApi();
        final container = ProviderContainer(overrides: overrides(api: api));
        addTearDown(container.dispose);
        container.read(pcOutboxRetryProvider);
        await container
            .read(pcOutboxProvider.notifier)
            .add('https://x.test/a', 'best');
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        expect(api.submitted.single.$1, 'https://x.test/a');
        expect(container.read(pcOutboxProvider), isEmpty);
      },
    );

    test(
      'stops at the first that does not reach it, and keeps the rest',
      () async {
        final container = ProviderContainer(overrides: overrides());
        addTearDown(container.dispose);
        final outbox = container.read(pcOutboxProvider.notifier);
        await outbox.add('https://x.test/a', 'best');
        await outbox.add('https://x.test/b', '720');
        final gone = FakeApi()..reachable = false;
        expect(await outbox.send(gone), isEmpty);
        expect(container.read(pcOutboxProvider), hasLength(2));
      },
    );

    test('they wait through a restart, and go with the pairing', () async {
      final first = ProviderContainer(overrides: overrides(at: 'nowhere'));
      await first
          .read(pcOutboxProvider.notifier)
          .add('https://x.test/a', '480');
      first.dispose();

      final again = ProviderContainer(overrides: overrides(at: 'nowhere'));
      addTearDown(again.dispose);
      again.read(pcOutboxProvider);
      await Future<void>.delayed(Duration.zero);
      final kept = again.read(pcOutboxProvider).single;
      expect((kept.url, kept.quality), ('https://x.test/a', '480'));

      await again.read(pcPairingProvider.notifier).forget();
      expect(again.read(pcOutboxProvider), isEmpty);
      expect(await store.getString(pcOutboxKey), isNull);
    });

    testWidgets('the computer page lists them, and one can be taken back', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides(at: 'nowhere'),
          child: MaterialApp(
            theme: vhTheme(VhVariant.phone, Brightness.light),
            locale: const Locale('en'),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            home: const Scaffold(body: PcOutboxSection()),
          ),
        ),
      );
      expect(find.byType(ListTile), findsNothing);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PcOutboxSection)),
      );
      await container
          .read(pcOutboxProvider.notifier)
          .add('https://x.test/a', 'best');
      await tester.pumpAndSettle();
      expect(find.text(l.pcOutboxTitle(1)), findsOneWidget);
      expect(find.text('https://x.test/a'), findsOneWidget);
      await tester.tap(find.byTooltip(l.remove));
      await tester.pumpAndSettle();
      expect(container.read(pcOutboxProvider), isEmpty);
      expect(find.text(l.pcOutboxTitle(1)), findsNothing);
    });
  });

  group('finding the computer to pair', () {
    Future<void> open(WidgetTester tester, List<PcFound> pairable) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides(pairing: null, pairable: pairable),
          child: MaterialApp(
            theme: vhTheme(VhVariant.phone, Brightness.light),
            locale: const Locale('en'),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(child: PcSettingsFields()),
            ),
          ),
        ),
      );
      await tester.tap(find.text(l.pcFindOnNetwork));
      await tester.pumpAndSettle();
    }

    testWidgets('the address is filled in; only the code is typed', (
      tester,
    ) async {
      await open(tester, const [
        PcFound(host: '192.168.1.30', port: 50000, name: 'HOME-PC'),
      ]);
      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(fields.elementAt(0).controller!.text, '192.168.1.30');
      expect(fields.elementAt(1).controller!.text, '50000');
      expect(find.text(l.pcFound('HOME-PC')), findsOneWidget);
    });

    testWidgets('none found says where to look', (tester) async {
      await open(tester, const []);
      expect(find.text(l.pcFindNone), findsOneWidget);
    });
  });
}
