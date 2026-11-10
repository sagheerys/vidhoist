import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/batch/batch_providers.dart';
import 'package:vidhoist_mobile/features/batch/batch_screen.dart';
import 'package:vidhoist_mobile/features/home/link_preview_view.dart';
import 'package:vidhoist_mobile/features/home/quick_download.dart';
import 'package:vidhoist_mobile/features/pc/pc_destination.dart';
import 'package:vidhoist_mobile/features/pc/pc_follow.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_outbox.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_send.dart';
import 'package:vidhoist_mobile/features/pc/pc_stream.dart';
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

/// The computer takes [left] links, then is gone; it counts each look.
class _Api extends FakeApi {
  int left = 1 << 20;
  int looks = 0;
  PcLinkFailure? fails;

  @override
  Future<PcTask> submit(String url, String quality) {
    if (fails case final failure?) throw PcLinkException(failure);
    if (left-- <= 0) reachable = false;
    return super.submit(url, quality);
  }

  @override
  Future<List<PcTask>> tasks() {
    looks++;
    return super.tasks();
  }
}

const _running = PcTask(
  id: 't1',
  url: 'https://youtu.be/rust',
  title: 'Rust for TypeScript devs',
  phase: 'downloading',
);

PcTask _as(String phase) => PcTask(
  id: _running.id,
  url: _running.url,
  title: _running.title,
  phase: phase,
);

const _playlist = 'https://www.youtube.com/playlist?list=PL123';
const _tracks = [
  PlaylistTrack(url: 'https://www.youtube.com/watch?v=a', title: 'One'),
  PlaylistTrack(url: 'https://www.youtube.com/watch?v=b', title: 'Two'),
  PlaylistTrack(url: 'https://www.youtube.com/watch?v=c', title: 'Three'),
];

/// Every link from the phone goes where the owner last sent one: the add
/// sheet, the batch screen, a quick download; and a download on the
/// computer is followed while the app is in front.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late MemoryKeyValueStore store;
  late MemorySecretStore secrets;

  setUp(() async {
    store = MemoryKeyValueStore();
    secrets = MemorySecretStore();
    await secrets.write(pcSecretKey, _pairing.secret);
  });

  List<Override> overrides(
    FakeApi api, {
    PcPairing? pairing = _pairing,
    bool toPc = true,
    bool quick = true,
  }) => [
    keyValueStoreProvider.overrideWithValue(store),
    secretStoreProvider.overrideWithValue(secrets),
    prefsMutexProvider.overrideWithValue(PrefsMutex()),
    initialSettingsProvider.overrideWithValue(
      PhoneSettings(quickDownload: quick),
    ),
    loggerProvider.overrideWithValue(
      VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc_send.log'),
    ),
    initialPcPairingProvider.overrideWithValue(pairing),
    initialSendToPcProvider.overrideWithValue(toPc),
    pcClientProvider.overrideWith(
      (ref) => ref.watch(pcPairingProvider) == null ? null : api,
    ),
    pcFinderProvider.overrideWithValue((_) async => null),
    // No engine: a link that went to the phone would show "no server".
    downloadEngineProvider.overrideWithValue(null),
    linkPreviewResolverProvider.overrideWithValue(
      ClipPreviewResolver(httpGet: (_) async => '{}'),
    ),
    playlistPreviewProvider.overrideWith(
      (ref, url) async => const PlaylistPreview(
        kind: PlaylistKind.youtube,
        title: 'A course',
        tracks: _tracks,
      ),
    ),
  ];

  /// [home] under a router, as in the app: the add sheet needs one.
  Widget app(List<Override> overrides, Widget home) => ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => home)],
      ),
      theme: vhTheme(VhVariant.phone, Brightness.light),
      locale: const Locale('en'),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
    ),
  );

  ProviderContainer containerOf(WidgetTester tester, Finder finder) =>
      ProviderScope.containerOf(tester.element(finder));

  group('sending, in order', () {
    test('**the guard**: gone halfway, the rest wait in their order', () async {
      final api = _Api()..left = 1;
      final container = ProviderContainer(overrides: overrides(api));
      addTearDown(container.dispose);
      final result = await sendLinksToPc(
        view: container.read(pcViewProvider.notifier),
        outbox: container.read(pcOutboxProvider.notifier),
        urls: [for (final t in _tracks) t.url],
        quality: '720',
      );
      expect(result.tasks, hasLength(1));
      expect(result.queued, 2);
      expect(api.submitted.single, (_tracks[0].url, '720'));
      expect(
        [for (final q in container.read(pcOutboxProvider)) (q.url, q.quality)],
        [(_tracks[1].url, '720'), (_tracks[2].url, '720')],
      );
    });

    test('one refused does not stop the next; unpaired stops all', () async {
      final api = _Api()..refuse = {_tracks[1].url};
      final container = ProviderContainer(overrides: overrides(api));
      addTearDown(container.dispose);
      Future<PcSendResult> send() => sendLinksToPc(
        view: container.read(pcViewProvider.notifier),
        outbox: container.read(pcOutboxProvider.notifier),
        urls: [for (final t in _tracks) t.url],
        quality: 'best',
      );
      final refused = await send();
      expect(refused.tasks, hasLength(2));
      expect(refused.failure, PcLinkFailure.refused);
      api.fails = PcLinkFailure.unauthorized;
      final unpaired = await send();
      expect(unpaired.tasks, isEmpty);
      expect(unpaired.queued, 0);
      expect(container.read(pcOutboxProvider), isEmpty);
    });
  });

  group('the batch screen', () {
    Future<void> open(WidgetTester tester, List<Override> overrides) async {
      final router = GoRouter(
        initialLocation: '/batch',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Scaffold()),
          GoRoute(
            path: '/batch',
            builder: (_, _) => const BatchScreen(playlistUrl: _playlist),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides,
          child: MaterialApp.router(
            routerConfig: router,
            theme: vhTheme(VhVariant.phone, Brightness.light),
            locale: const Locale('en'),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('**the guard**: the computer is offered, and takes the '
        'selection one link at a time, in the playlist\'s order', (
      tester,
    ) async {
      final api = _Api();
      await open(tester, overrides(api, toPc: false));
      expect(find.text(l.storageLocation), findsOneWidget);
      expect(find.text(l.batchDownloadSelected), findsOneWidget);
      await tester.tap(find.text('HOME-PC'));
      await tester.pumpAndSettle();
      // Taken out and put back: last in the selection, still second.
      await tester.tap(find.text('Two'));
      await tester.pump();
      await tester.tap(find.text('Two'));
      await tester.pump();
      await tester.tap(find.text('720'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.pcSendToPc));
      await tester.pump();
      // Not settled: that would wait out the notice itself.
      await tester.pump(const Duration(milliseconds: 500));
      expect(api.submitted, [for (final t in _tracks) (t.url, '720')]);
      expect(find.text(l.pcSentMany(3, 'HOME-PC')), findsOneWidget);
      expect(find.text(l.noServerTitle), findsNothing);
      expect(await store.getBool(pcSendToPcKey), isTrue, reason: 'kept');
    });

    testWidgets('away, the selection waits for it', (tester) async {
      final api = _Api()..reachable = false;
      await open(tester, overrides(api));
      expect(find.text(l.pcWillSend), findsOneWidget);
      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.pcSendToPc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(l.pcQueuedMany(2, 'HOME-PC')), findsOneWidget);
      final container = containerOf(tester, find.byType(Scaffold).first);
      expect(
        [for (final q in container.read(pcOutboxProvider)) q.url],
        [_tracks[1].url, _tracks[2].url],
      );
    });

    testWidgets('unpaired, the screen is as it was', (tester) async {
      await open(tester, overrides(_Api(), pairing: null));
      expect(find.text(l.storageLocation), findsNothing);
      expect(find.text(l.batchDownloadSelected), findsOneWidget);
    });
  });

  group('a quick download', () {
    Future<bool?> quick(WidgetTester tester, List<Override> overrides) async {
      bool? started;
      await tester.pumpWidget(
        app(
          overrides,
          Consumer(
            builder: (context, ref, _) => Scaffold(
              body: TextButton(
                onPressed: () => started = startQuickDownload(
                  context,
                  ref,
                  'https://youtu.be/rust',
                ),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      return started;
    }

    testWidgets('**the guard**: last sent to the computer, it goes there; '
        'the undo takes it back and opens the sheet', (tester) async {
      final api = _Api()..live = const [];
      expect(await quick(tester, overrides(api)), isTrue);
      expect(api.submitted.single, ('https://youtu.be/rust', 'best'));
      expect(find.text(l.pcSent('HOME-PC')), findsOneWidget);
      await tester.tap(find.text(l.undo));
      await tester.pumpAndSettle();
      expect(api.cancelled, ['t9']);
      expect(find.text(l.addUrl), findsOneWidget);
    });

    testWidgets('last kept on the phone, the computer is not asked', (
      tester,
    ) async {
      final api = _Api();
      // No engine here, so the phone's path hands over to the sheet.
      expect(await quick(tester, overrides(api, toPc: false)), isFalse);
      expect(api.submitted, isEmpty);
    });

    testWidgets('away, it waits for the computer', (tester) async {
      final api = _Api()..reachable = false;
      expect(await quick(tester, overrides(api)), isTrue);
      expect(find.text(l.pcQueued('HOME-PC')), findsOneWidget);
      final container = containerOf(tester, find.text('go'));
      expect(container.read(pcOutboxProvider).single.url, contains('rust'));
    });

    testWidgets('quick download off: the sheet, as before', (tester) async {
      final api = _Api();
      expect(await quick(tester, overrides(api, quick: false)), isFalse);
      expect(api.submitted, isEmpty);
    });
  });

  group('following the computer', () {
    testWidgets('**the guard**: a download there is followed while the app '
        'is in front, counted on the tab, and told when done; nothing is '
        'asked from behind', (tester) async {
      final api = _Api()..live = const [_running];
      final container = ProviderContainer(overrides: overrides(api));
      final done = <PcTask>[];
      container.listen(pcDoneProvider, (_, next) {
        if (next.valueOrNull case final task?) done.add(task);
      });
      container.listen(pcRunningProvider, (_, _) {});

      await container.read(pcViewProvider.notifier).glance();
      expect(container.read(pcRunningProvider), 1);
      final first = api.looks;
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(api.looks, first + 1, reason: 'followed with the page closed');

      // Behind another app: no more looks, even after one asked for by
      // something else (a waiting link's retry).
      container.read(pcForegroundProvider.notifier).state = false;
      await container.read(pcViewProvider.notifier).refresh(library: false);
      await tester.pump(const Duration(seconds: 30));
      expect(api.looks, first + 2);

      // Back in front: one look at once, then followed again.
      api.live = [_as('completed')];
      container.read(pcForegroundProvider.notifier).state = true;
      await tester.pump();
      await tester.pump();
      expect(done.single.title, _running.title);
      expect(container.read(pcRunningProvider), 0);
      final settled = api.looks;
      await tester.pump(const Duration(seconds: 30));
      expect(api.looks, settled, reason: 'nothing left to follow');
      container.dispose();
    });

    testWidgets('a computer that stops answering takes its count away', (
      tester,
    ) async {
      final api = _Api()..live = const [_running];
      final container = ProviderContainer(overrides: overrides(api));
      container.listen(pcRunningProvider, (_, _) {});
      await container.read(pcViewProvider.notifier).glance();
      expect(container.read(pcRunningProvider), 1);
      api.reachable = false;
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(container.read(pcRunningProvider), 0);
      final looks = api.looks;
      await tester.pump(const Duration(seconds: 30));
      expect(api.looks, looks, reason: 'not followed while away');
      container.dispose();
    });

    testWidgets('done: a word in the app, with Play for the clip', (
      tester,
    ) async {
      final api = _Api()..live = const [_running];
      await tester.pumpWidget(
        app(
          overrides(api),
          Consumer(
            builder: (context, ref, _) {
              listenPcDone(ref, context);
              return const Scaffold(body: Text('shell'));
            },
          ),
        ),
      );
      final container = containerOf(tester, find.text('shell'));
      await container.read(pcViewProvider.notifier).glance();
      api.live = [_as('completed')];
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      await tester.pump();
      expect(find.text(l.pcDoneOnPc(_running.title!)), findsOneWidget);
      expect(find.text(l.play), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
    });

    testWidgets('a failed download is not called done', (tester) async {
      final api = _Api()..live = const [_running];
      final container = ProviderContainer(overrides: overrides(api));
      final done = <PcTask>[];
      container.listen(pcDoneProvider, (_, next) {
        if (next.valueOrNull case final task?) done.add(task);
      });
      await container.read(pcViewProvider.notifier).glance();
      api.live = [_as('failed')];
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(done, isEmpty);
      container.dispose();
    });
  });

  group('covers in the player', () {
    late PcStreamProxy proxy;

    setUp(() async {
      proxy = PcStreamProxy(() => null);
      await proxy.start();
    });

    tearDown(() => proxy.stop());

    test('**the guard**: a cover the computer keeps has an address the '
        'player\'s list can load', () {
      const kept = PcItem(id: 'i7', title: 'Kept', hasCover: true);
      final url = pcPlaylistItem(kept, proxy: proxy).artworkUrl;
      expect(url, startsWith('http://127.0.0.1:'));
      expect(url, endsWith('/cover/i7'));
    });

    test('a web thumbnail stays as it is; no cover, no address', () {
      const web = PcItem(id: 'i8', title: 'Web', thumbnail: 'https://x/t.jpg');
      expect(pcPlaylistItem(web, proxy: proxy).artworkUrl, 'https://x/t.jpg');
      const bare = PcItem(id: 'i9', title: 'Bare');
      expect(pcPlaylistItem(bare, proxy: proxy).artworkUrl, isNull);
    });
  });
}
