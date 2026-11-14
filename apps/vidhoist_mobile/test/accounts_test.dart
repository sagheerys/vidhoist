import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/accounts/accounts_state.dart';
import 'package:vidhoist_mobile/features/accounts/cookie_jar.dart';
import 'package:vidhoist_mobile/features/accounts/login_sites.dart';
import 'package:vidhoist_mobile/features/accounts/session_watch.dart';
import 'package:vh_core/vh_core.dart';

/// The in-app browser's jar, scripted: what each page's cookies are, and
/// whether it was told to clear.
class FakeJar implements WebCookieJar {
  final Map<String, String> pages = {};
  var cleared = 0;

  @override
  Future<Map<String, String>> headers(List<String> urls) async => {
    for (final url in urls) url: pages[url] ?? '',
  };

  @override
  Future<void> clear() async {
    cleared++;
    pages.clear();
  }
}

/// **Settings › Accounts keeps a site's sign-in for yt-dlp** (2026-11-09):
/// the session cookie decides, the file holds every site at once, and
/// signing out of one keeps the others.
void main() {
  group('LoginSite', () {
    test('names its site as the cookies file does', () {
      expect(LoginSite.youtube.domain, 'youtube.com');
      expect(LoginSite.x.domain, 'x.com');
      expect(LoginSite.vimeo.domain, 'vimeo.com');
    });

    test('is signed in by its session cookie, not by any cookie', () {
      expect(
        LoginSite.youtube.signedInPer({
          'youtube.com': {'CONSENT', 'PREF'},
        }),
        isFalse,
      );
      expect(
        LoginSite.youtube.signedInPer({
          'youtube.com': {'SID', 'HSID'},
        }),
        isTrue,
      );
      expect(
        LoginSite.instagram.signedInPer({
          'instagram.com': {'sessionid'},
        }),
        isTrue,
      );
    });

    test('is found by the name a route carries', () {
      expect(LoginSite.byName('tiktok'), LoginSite.tiktok);
      expect(LoginSite.byName('nothing'), isNull);
    });
  });

  group('browserUserAgent', () {
    test('drops what names a WebView and nothing else', () {
      const webView =
          'Mozilla/5.0 (Linux; Android 14; SM-S908E Build/UP1A; wv) '
          'AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 '
          'Chrome/130.0.6723.58 Mobile Safari/537.36';
      expect(
        browserUserAgent(webView),
        'Mozilla/5.0 (Linux; Android 14; SM-S908E Build/UP1A) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/130.0.6723.58 Mobile Safari/537.36',
      );
    });

    test('leaves a browser agent as it is', () {
      const chrome =
          'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36';
      expect(browserUserAgent(chrome), chrome);
      expect(browserUserAgent(''), '');
    });
  });

  group('Accounts', () {
    late Directory dir;
    late FakeJar jar;
    late Accounts accounts;
    var changes = 0;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('vh_accounts_');
      jar = FakeJar();
      changes = 0;
      accounts = Accounts(
        path: '${dir.path}/private/cookies.txt',
        jar: jar,
        onChanged: () => changes++,
      );
    });

    tearDown(() => dir.deleteSync(recursive: true));

    File file() => File(accounts.path);

    test('keeps nothing while the browser is not signed in', () async {
      jar.pages['https://www.youtube.com/'] = 'CONSENT=YES+; PREF=f1';
      expect(await accounts.keep(LoginSite.youtube), isFalse);
      expect(await accounts.signedInBrowser(LoginSite.youtube), isFalse);
      expect(file().existsSync(), isFalse);
      expect(changes, 0);
    });

    test('**the guard**: X is kept only once `ct0` is there beside '
        '`auth_token`; yt-dlp sends both, and X refuses one alone', () async {
      jar.pages['https://x.com/'] = 'guest_id=g; auth_token=a';
      expect(await accounts.keep(LoginSite.x), isFalse);
      expect(file().existsSync(), isFalse);

      jar.pages['https://x.com/'] = 'guest_id=g; auth_token=a; ct0=c';
      expect(await accounts.keep(LoginSite.x), isTrue);
      final text = utf8.decode(file().readAsBytesSync());
      expect(text, contains('	auth_token	a'));
      expect(text, contains('	ct0	c'));
    });

    test('keeps the signed-in site in a file yt-dlp reads', () async {
      jar.pages['https://www.youtube.com/'] = 'SID=s1; LOGIN_INFO=l';
      jar.pages['https://www.google.com/'] = 'NID=n';
      expect(await accounts.signedInBrowser(LoginSite.youtube), isTrue);
      expect(await accounts.keep(LoginSite.youtube), isTrue);

      final text = utf8.decode(file().readAsBytesSync());
      expect(text, startsWith(CookieFiles.header));
      expect(text, contains('.youtube.com\tTRUE\t/\tTRUE\t\tSID\ts1'));
      expect(text, contains('.google.com\tTRUE\t/\tTRUE\t\tNID\tn'));
      expect(changes, 1);
    });

    test('a second site joins the first, and a fresh sign-in replaces '
        'the old session', () async {
      jar.pages['https://www.youtube.com/'] = 'SID=old';
      await accounts.keep(LoginSite.youtube);
      jar.pages['https://www.instagram.com/'] = 'sessionid=i';
      await accounts.keep(LoginSite.instagram);
      jar.pages['https://www.youtube.com/'] = 'SID=new';
      await accounts.keep(LoginSite.youtube);

      final names = CookieFiles.names(file().readAsBytesSync());
      expect(names.keys, containsAll(['youtube.com', 'instagram.com']));
      final text = utf8.decode(file().readAsBytesSync());
      expect(text, contains('SID\tnew'));
      expect(text, isNot(contains('SID\told')));
    });

    test('forgetting one site keeps the other in the file and signs the '
        'browser out', () async {
      jar.pages['https://www.youtube.com/'] = 'SID=s';
      jar.pages['https://www.instagram.com/'] = 'sessionid=i';
      await accounts.keep(LoginSite.youtube);
      await accounts.keep(LoginSite.instagram);

      await accounts.forget(LoginSite.youtube);

      final names = CookieFiles.names(file().readAsBytesSync());
      expect(names.keys, ['instagram.com']);
      expect(jar.cleared, 1);
      // Signing in again finds no session left over in the browser.
      expect(await accounts.keep(LoginSite.youtube), isFalse);
    });

    test('forgetting the last site removes the file', () async {
      jar.pages['https://x.com/'] = 'auth_token=t; ct0=c';
      await accounts.keep(LoginSite.x);
      await accounts.forget(LoginSite.x);
      expect(file().existsSync(), isFalse);
      // Forgetting what is not there is no error.
      await accounts.forget(LoginSite.x);
      await accounts.forgetAll();
      expect(jar.cleared, 3);
    });

    test('signedInSitesProvider reads the sites off the file', () async {
      final container = ProviderContainer(
        overrides: [
          cookiesFileProvider.overrideWithValue(accounts.path),
          webCookieJarProvider.overrideWithValue(jar),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(signedInSitesProvider), isEmpty);

      jar.pages['https://vimeo.com/'] = 'vimeo=v';
      jar.pages['https://www.tiktok.com/'] = 'tt_csrf=x';
      final wired = container.read(accountsProvider)!;
      await wired.keep(LoginSite.vimeo);
      expect(await wired.keep(LoginSite.tiktok), isFalse);
      expect(container.read(signedInSitesProvider), {LoginSite.vimeo});

      await wired.forgetAll();
      expect(container.read(signedInSitesProvider), isEmpty);
    });

    test('**the guard**: a cookies file the person picked is merged over '
        'the sign-ins, a listed site reads signed in, and the rest show '
        'on their own', () async {
      final container = ProviderContainer(
        overrides: [
          cookiesFileProvider.overrideWithValue(accounts.path),
          webCookieJarProvider.overrideWithValue(jar),
        ],
      );
      addTearDown(container.dispose);
      jar.pages['https://vimeo.com/'] = 'vimeo=v';
      final wired = container.read(accountsProvider)!;
      await wired.keep(LoginSite.vimeo);

      final picked = utf8.encode(
        '# Netscape HTTP Cookie File\n'
        '#HttpOnly_.x.com\tTRUE\t/\tTRUE\t0\tauth_token\ta\n'
        '.x.com\tTRUE\t/\tTRUE\t0\tct0\tc\n'
        '.example.org\tTRUE\t/\tFALSE\t0\tsid\ts\n',
      );
      expect(await wired.importFile(picked), ['example.org', 'x.com']);
      expect(container.read(signedInSitesProvider), {
        LoginSite.vimeo,
        LoginSite.x,
      });
      expect(container.read(fileOnlySitesProvider), ['example.org']);

      // Removing what a file brought leaves the browser signed in.
      await wired.forgetSite('example.org');
      expect(container.read(fileOnlySitesProvider), isEmpty);
      expect(container.read(signedInSitesProvider), hasLength(2));
      expect(jar.cleared, 0);
    });

    test(
      'a file with no cookie in it is refused and nothing is touched',
      () async {
        jar.pages['https://vimeo.com/'] = 'vimeo=v';
        await accounts.keep(LoginSite.vimeo);
        final before = file().readAsStringSync();
        expect(
          await accounts.importFile(utf8.encode('{"cookies": []}')),
          isNull,
        );
        expect(file().readAsStringSync(), before);
      },
    );

    test('with no file path there are no accounts and no sites', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(accountsProvider), isNull);
      expect(container.read(signedInSitesProvider), isEmpty);
    });
  });

  group('SessionWatch', () {
    test('**the guard**: asks again and again with no page loading, and '
        'not once stopped', () async {
      var asked = 0;
      final watch = SessionWatch(
        () async => asked++,
        every: const Duration(milliseconds: 5),
      )..start();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      watch.stop();
      expect(asked, greaterThan(2));
      expect(watch.watching, isFalse);

      final before = asked;
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(asked, before);
    });

    test('a second start keeps one clock', () async {
      var asked = 0;
      final watch =
          SessionWatch(
              () async => asked++,
              every: const Duration(milliseconds: 20),
            )
            ..start()
            ..start();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      watch.stop();
      expect(asked, inInclusiveRange(0, 3));
    });
  });
}
