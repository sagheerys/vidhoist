import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/accounts/accounts_fields.dart';
import 'package:vidhoist_mobile/features/accounts/accounts_state.dart';
import 'package:vidhoist_mobile/features/accounts/cookie_file_fields.dart';
import 'package:vidhoist_mobile/features/accounts/login_sites.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/downloads_sheet.dart';
import 'package:vidhoist_mobile/features/settings/settings_page.dart';
import 'package:vidhoist_mobile/features/settings/settings_sections.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'accounts_test.dart';
import 'device_matrix.dart';

/// **Settings › Accounts on the screen** (2026-11-09): a row per site that
/// says whether it is signed in and offers the one action that fits, a
/// way to forget everything, and the sign-in offered right on a failed
/// download that wanted it.
void main() {
  late Directory dir;
  late FakeJar jar;
  late String path;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('vh_accounts_ui_');
    jar = FakeJar();
    path = '${dir.path}/cookies.txt';
  });

  tearDown(() => dir.deleteSync(recursive: true));

  List<Override> overrides({bool disk = true}) => [
    cookiesFileProvider.overrideWithValue(disk ? path : null),
    webCookieJarProvider.overrideWithValue(jar),
  ];

  Widget app(Widget home, {Locale? locale, List<Override>? extra}) =>
      ProviderScope(
        overrides: [...overrides(), ...?extra],
        child: MaterialApp.router(
          locale: locale,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => home),
              GoRoute(
                path: '/settings/login/:site',
                builder: (_, state) =>
                    Text('login ${state.pathParameters['site']}'),
              ),
            ],
          ),
        ),
      );

  Future<void> signIn(LoginSite site, String header) async {
    jar.pages[site.pages.first] = header;
    final container = ProviderContainer(overrides: overrides());
    addTearDown(container.dispose);
    expect(await container.read(accountsProvider)!.keep(site), isTrue);
  }

  testWidgets('every site has a row, signed out, offering a sign-in', (
    tester,
  ) async {
    await tester.pumpWidget(app(const SettingsPage(SettingsPane.accounts)));
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AccountsFields)).vhl;
    for (final site in LoginSite.values) {
      expect(find.text(site.label), findsOneWidget);
    }
    expect(
      find.text(l10n.accountSignedOut),
      findsNWidgets(LoginSite.values.length),
    );
    expect(
      find.text(l10n.accountSignIn),
      findsNWidgets(LoginSite.values.length),
    );
    expect(find.text(l10n.accountsClearAll), findsNothing);
    expect(find.text(l10n.accountsBanRisk), findsOneWidget);
  });

  testWidgets('the sign-in button opens the site\'s sign-in page', (
    tester,
  ) async {
    await tester.pumpWidget(app(const SettingsPage(SettingsPane.accounts)));
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AccountsFields)).vhl;
    await tester.tap(find.text(l10n.accountSignIn).first);
    await tester.pumpAndSettle();
    expect(find.text('login youtube'), findsOneWidget);
  });

  testWidgets('a signed-in site says so, signs out from its row, and the '
      'rest can be forgotten at once', (tester) async {
    await signIn(LoginSite.youtube, 'SID=s');
    await signIn(LoginSite.vimeo, 'vimeo=v');
    tester.view.physicalSize = const Size(411, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const SettingsPage(SettingsPane.accounts)));
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AccountsFields)).vhl;
    expect(find.text(l10n.accountSignedIn), findsNWidgets(2));
    expect(find.text(l10n.accountSignOut), findsNWidgets(2));
    expect(find.text(l10n.accountsClearAll), findsOneWidget);

    await tester.tap(find.text(l10n.accountSignOut).first);
    await tester.pumpAndSettle();
    expect(find.text(l10n.accountSignedIn), findsOneWidget);
    expect(find.text(l10n.accountSignedOutOf('YouTube')), findsOneWidget);
    expect(jar.cleared, 1);

    await tester.tap(find.text(l10n.accountsClearAll));
    await tester.pumpAndSettle();
    expect(find.text(l10n.accountSignedIn), findsNothing);
    expect(find.text(l10n.accountsCleared), findsOneWidget);
    expect(File(path).existsSync(), isFalse);
  });

  testWidgets('without a disk the buttons are there but do nothing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides(disk: false),
        child: MaterialApp(
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          home: const SettingsPage(SettingsPane.accounts),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(find.byType(FilledButton).first);
    expect(button.onPressed, isNull);
  });

  test('the settings home line names who is signed in', () {
    final en = lookupVhLocalizations(const Locale('en'));
    expect(accountsSummary(en, const {}), en.cookiesSubtitle);
    expect(
      accountsSummary(en, {LoginSite.vimeo, LoginSite.youtube}),
      en.settingsValueSignedIn(vhLtrRun('YouTube · Vimeo')),
    );
  });

  group('a cookies file instead of a sign-in', () {
    final exported = utf8.encode(
      '# Netscape HTTP Cookie File\n'
      '#HttpOnly_.x.com\tTRUE\t/\tTRUE\t0\tauth_token\ta\n'
      '.x.com\tTRUE\t/\tTRUE\t0\tct0\tc\n'
      '.example.org\tTRUE\t/\tFALSE\t0\tsid\ts\n',
    );

    Future<VhLocalizations> pick(WidgetTester tester, List<int>? file) async {
      // Tall enough for the whole page: the import sits below six sites.
      tester.view.physicalSize = const Size(600, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        app(
          const SettingsPage(SettingsPane.accounts),
          extra: [cookiesPickerProvider.overrideWithValue(() async => file)],
        ),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(AccountsFields)).vhl;
      await tester.tap(find.text(l10n.accountsFilePick));
      await tester.pumpAndSettle();
      return l10n;
    }

    testWidgets('**the guard**: it is kept, its listed site reads signed in, '
        'and a site with no row shows on its own, removable', (tester) async {
      final l10n = await pick(tester, exported);
      expect(
        find.text(l10n.desktopCookiesKeptFor(vhLtrRun('example.org · x.com'))),
        findsOneWidget,
      );
      final scope = ProviderScope.containerOf(
        tester.element(find.byType(AccountsFields)),
      );
      expect(scope.read(signedInSitesProvider), {LoginSite.x});
      expect(find.text('example.org'), findsOneWidget);

      await tester.tap(find.text(l10n.remove));
      await tester.pumpAndSettle();
      expect(find.text('example.org'), findsNothing);
      expect(scope.read(signedInSitesProvider), {LoginSite.x});
      expect(jar.cleared, 0);
    });

    testWidgets('a file with no cookie in it is refused, and says so', (
      tester,
    ) async {
      final l10n = await pick(tester, utf8.encode('{"cookies": []}'));
      expect(find.text(l10n.cookiesNotNetscape), findsOneWidget);
      expect(File(path).existsSync(), isFalse);
    });

    testWidgets('choosing nothing changes nothing', (tester) async {
      await pick(tester, null);
      expect(File(path).existsSync(), isFalse);
    });
  });

  testWidgets('the page holds at every size, both languages', (tester) async {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      await expectNoOverflow(
        tester,
        () => app(const SettingsPage(SettingsPane.accounts), locale: locale),
      );
    }
  });

  group('a download the site refused without a sign-in', () {
    final blocked =
        DownloadTask(
          inputUrl: 'https://www.instagram.com/p/abc/',
          quality: Quality.best,
        ).copyWith(
          phase: TaskPhase.failed,
          error: const PlatformBlockedException('login required'),
        );
    final broken = blocked.copyWith(
      error: const EngineFailureException(YtDlpErrorKind.failed, 'x'),
    );

    Future<VhLocalizations> open(WidgetTester tester, DownloadTask task) async {
      tester.view.physicalSize = const Size(384, 823);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final tasks = StreamController<List<DownloadTask>>();
      addTearDown(tasks.close);
      await tester.pumpWidget(
        app(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDownloadsSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
          extra: [
            downloadEngineProvider.overrideWithValue(null),
            engineTasksProvider.overrideWith((ref) => tasks.stream),
          ],
        ),
      );
      tasks.add([task]);
      await tester.pump();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return tester.element(find.text('open')).vhl;
    }

    testWidgets('offers the sign-in beside the retry', (tester) async {
      final l10n = await open(tester, blocked);
      expect(find.text(l10n.mobileSignInNeeded), findsOneWidget);
      expect(find.text(l10n.accountSignIn), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('any other failure offers the retry alone', (tester) async {
      final l10n = await open(tester, broken);
      expect(find.text(l10n.accountSignIn), findsNothing);
      expect(find.text(l10n.retry), findsOneWidget);
    });
  });
}
