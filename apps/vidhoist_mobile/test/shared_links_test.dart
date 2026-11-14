import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shared_links.dart';

/// Several links shared at once are asked about before any of them starts
/// downloading: a shared chat or page can carry hundreds.
void main() {
  const links = [
    'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
    'https://vimeo.com/76979871',
  ];

  Widget host(_Engine engine, {bool capped = false, String language = 'en'}) =>
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          secretStoreProvider.overrideWithValue(MemorySecretStore()),
          prefsMutexProvider.overrideWithValue(PrefsMutex()),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          loggerProvider.overrideWithValue(
            VhLogger(filePath: '${Directory.systemTemp.path}/vh_links.log'),
          ),
          downloadEngineProvider.overrideWithValue(engine),
        ],
        child: MaterialApp.router(
          locale: Locale(language),
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => Scaffold(
                  body: Consumer(
                    builder: (context, ref, _) => TextButton(
                      onPressed: () => submitSharedLinks(
                        context,
                        ref,
                        links,
                        capped: capped,
                        note: (_) {},
                      ),
                      child: const Text('SHARE'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  testWidgets('**the guard**: nothing starts until the user agrees, and '
      'nothing at all on cancel', (tester) async {
    final engine = _Engine();
    await tester.pumpWidget(host(engine));
    await tester.tap(find.text('SHARE'));
    await tester.pumpAndSettle();
    expect(find.text('Add 3 links?'), findsOneWidget);
    expect(find.text('Each one downloads to this phone.'), findsOneWidget);
    expect(engine.urls, isEmpty);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(engine.urls, isEmpty);
  });

  testWidgets('agreeing starts every link', (tester) async {
    final engine = _Engine();
    await tester.pumpWidget(host(engine));
    await tester.tap(find.text('SHARE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add them'));
    await tester.pumpAndSettle();
    expect(engine.urls, links);
  });

  testWidgets('a share past the ceiling says the rest was left', (
    tester,
  ) async {
    final engine = _Engine();
    await tester.pumpWidget(host(engine, capped: true));
    await tester.tap(find.text('SHARE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add them'));
    await tester.pump();
    expect(
      find.text('Only the first $maxSharedLinks links were added.'),
      findsOneWidget,
    );
  });

  testWidgets('the question reads in Arabic, at the largest text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: host(_Engine(), language: 'ar'),
      ),
    );
    await tester.tap(find.text('SHARE'));
    await tester.pumpAndSettle();
    expect(find.text('إضافة 3 روابط؟'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _Engine implements LocalDownloadEngine {
  final urls = <String>[];

  @override
  DownloadTask submit(
    String url,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
    ClipRange? clip,
  }) {
    urls.add(url);
    return DownloadTask(inputUrl: url, quality: quality, folder: folder);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
