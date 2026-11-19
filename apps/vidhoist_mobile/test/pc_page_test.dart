import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/pc/pc_downloads.dart';
import 'package:vidhoist_mobile/features/pc/pc_lists_screen.dart';
import 'package:vidhoist_mobile/features/pc/pc_outbox.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_screen.dart';
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

PcTask _task(String id, String title, String phase, [double progress = 0]) =>
    PcTask(
      id: id,
      url: 'https://youtu.be/$id',
      title: title,
      phase: phase,
      progress: progress,
    );

const _evening = PcList(id: 'l1', name: 'Evening', count: 2, coverId: 'i1');

/// The computer's page, kept short however much is there: its downloads
/// fold into one line, its lists into another, and a clip is deleted there
/// only where the user allowed it, after asking.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late MemoryKeyValueStore store;
  late MemorySecretStore secrets;

  setUp(() async {
    store = MemoryKeyValueStore();
    secrets = MemorySecretStore();
    await secrets.write(pcSecretKey, _pairing.secret);
  });

  Widget app(FakeApi api) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      secretStoreProvider.overrideWithValue(secrets),
      prefsMutexProvider.overrideWithValue(PrefsMutex()),
      initialSettingsProvider.overrideWithValue(const PhoneSettings()),
      loggerProvider.overrideWithValue(
        VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc_page.log'),
      ),
      initialPcPairingProvider.overrideWithValue(_pairing),
      pcClientProvider.overrideWith((ref) => api),
      pcFinderProvider.overrideWithValue((_) async => null),
      downloadEngineProvider.overrideWithValue(null),
    ],
    child: MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/pc',
        routes: [
          GoRoute(
            path: '/pc',
            builder: (_, _) => const PcScreen(),
            routes: [
              GoRoute(
                path: 'lists',
                builder: (_, _) => const PcListsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, s) =>
                        PcListScreen(id: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      theme: vhTheme(VhVariant.phone, Brightness.light),
      locale: const Locale('en'),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
    ),
  );

  /// Lets the page's look and its answers land, without waiting on the
  /// two-second follow-up it keeps while something downloads.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> leave(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  }

  group('the downloads fold', () {
    testWidgets('**the guard**: two or more are one line, and the sheet '
        'shows them all', (tester) async {
      final api = FakeApi()
        ..live = [
          _task('a', 'First clip', 'downloading', 40),
          _task('b', 'Second clip', 'downloading', 60),
          _task('c', 'Third clip', 'queued'),
        ];
      await tester.pumpWidget(app(api));
      await settle(tester);
      expect(find.text(l.pcDownloadsCount(3)), findsOneWidget);
      expect(find.text('First clip'), findsNothing, reason: 'folded');
      expect(find.text(l.viewAll), findsOneWidget);

      await tester.tap(find.text(l.pcDownloadsCount(3)));
      await settle(tester);
      expect(find.text(l.pcDownloadsSheet), findsOneWidget);
      expect(find.text('${l.pcNow} · 2'), findsOneWidget);
      expect(find.text('${l.queuedSection} · 1'), findsOneWidget);
      for (final title in ['First clip', 'Second clip', 'Third clip']) {
        expect(find.text(title), findsOneWidget);
      }
      await leave(tester);
    });

    testWidgets('a link waiting to be sent counts with them', (tester) async {
      final api = FakeApi()..live = [_task('a', 'First clip', 'downloading')];
      await tester.pumpWidget(app(api));
      await settle(tester);
      expect(find.text('First clip'), findsOneWidget, reason: 'one: its card');
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PcScreen)),
      );
      api.reachable = false;
      await container
          .read(pcOutboxProvider.notifier)
          .add('https://youtu.be/later', 'best');
      await settle(tester);
      expect(find.text(l.pcDownloadsCount(2)), findsOneWidget);
      await leave(tester);
    });

    test('the line shows the share done of what is measured', () {
      expect(pcAverageProgress(const []), isNull);
      expect(pcAverageProgress([_task('a', 'A', 'queued')]), isNull);
      expect(
        pcAverageProgress([
          _task('a', 'A', 'downloading', 40),
          _task('b', 'B', 'downloading', 60),
          _task('c', 'C', 'queued'),
        ]),
        0.5,
      );
    });
  });

  group("the computer's lists", () {
    testWidgets('one line however many, then their page, then one list', (
      tester,
    ) async {
      final api = FakeApi()
        ..live = const []
        ..savedLists = [
          _evening,
          for (var i = 0; i < 30; i++)
            PcList(id: 'x$i', name: 'List $i', count: 1),
        ]
        ..listClips = {
          'l1': const PcList(
            id: 'l1',
            name: 'Evening',
            count: 2,
            items: [
              PcItem(id: 'i2', title: 'Night drive'),
              PcItem(id: 'i1', title: 'Rust for TypeScript devs'),
            ],
          ),
        };
      await tester.pumpWidget(app(api));
      await settle(tester);
      expect(find.text(l.pcLists), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
      expect(find.text('List 7'), findsNothing, reason: 'not on the page');

      await tester.tap(find.text(l.pcLists));
      await settle(tester);
      expect(find.text('Evening'), findsOneWidget);
      expect(find.text(l.queueItemsCount(2)), findsOneWidget);

      await tester.tap(find.text('Evening'));
      await settle(tester);
      expect(find.text(l.playAll), findsOneWidget);
      final titles = [
        for (final w in tester.widgetList<VhMediaCard>(
          find.byType(VhMediaCard),
        ))
          w.title,
      ];
      expect(titles, ['Night drive', 'Rust for TypeScript devs']);
      await leave(tester);
    });

    testWidgets('no line while it has none', (tester) async {
      final api = FakeApi()..live = const [];
      await tester.pumpWidget(app(api));
      await settle(tester);
      expect(find.text(l.pcLists), findsNothing);
      await leave(tester);
    });
  });

  group('deleting on the computer', () {
    Future<void> openMenu(WidgetTester tester) async {
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(VhMediaCard, 'Rust for TypeScript devs'),
          matching: find.byTooltip(l.itemOptions),
        ),
      );
      await settle(tester);
    }

    testWidgets('**the guard**: not offered unless the user allowed it', (
      tester,
    ) async {
      final api = FakeApi()..live = const [];
      await tester.pumpWidget(app(api));
      await settle(tester);
      await openMenu(tester);
      expect(find.text(l.pcCopyToPhone), findsOneWidget);
      expect(find.text(l.pcDelete), findsNothing);
      await leave(tester);
    });

    testWidgets('**the guard**: asked first, naming the computer; no means '
        'nothing goes', (tester) async {
      final api = FakeApi()
        ..live = const []
        ..canDelete = true;
      await tester.pumpWidget(app(api));
      await settle(tester);
      await openMenu(tester);
      await tester.tap(find.text(l.pcDelete));
      await settle(tester);
      expect(find.text(l.pcDeleteTitle('HOME-PC')), findsOneWidget);
      expect(
        find.text(l.pcDeleteBody('Rust for TypeScript devs')),
        findsOneWidget,
      );
      await tester.tap(find.text(l.cancel));
      await settle(tester);
      expect(api.deleted, isEmpty);

      await openMenu(tester);
      await tester.tap(find.text(l.pcDelete));
      await settle(tester);
      await tester.tap(find.widgetWithText(OutlinedButton, l.delete));
      await settle(tester);
      expect(api.deleted, ['i1']);
      expect(
        find.text(l.pcDeleted('Rust for TypeScript devs')),
        findsOneWidget,
      );
      await leave(tester);
    });

    testWidgets('a drive with no Recycle Bin is said, and nothing goes', (
      tester,
    ) async {
      final api = FakeApi()
        ..live = const []
        ..canDelete = true
        ..deleting = PcDeleteOutcome.noRecycleBin;
      await tester.pumpWidget(app(api));
      await settle(tester);
      await openMenu(tester);
      await tester.tap(find.text(l.pcDelete));
      await settle(tester);
      await tester.tap(find.widgetWithText(OutlinedButton, l.delete));
      await settle(tester);
      expect(find.text(l.pcDeleteNoBin), findsOneWidget);
      expect(api.deleted, isEmpty);
      await leave(tester);
    });
  });
}
