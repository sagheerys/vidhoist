import 'dart:convert';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

/// Lines as a browser exporter writes them: tab-separated, seven fields.
String row(String domain, String name, String value, {String path = '/'}) =>
    [domain, 'TRUE', path, 'TRUE', '1790000000', name, value].join('\t');

List<int> file(List<String> lines) => utf8.encode(
  '# Netscape HTTP Cookie File\n# comment\n\n${lines.join('\n')}\n',
);

List<String> cookiesIn(List<int>? merged) => const LineSplitter()
    .convert(utf8.decode(merged!))
    .where((l) => !l.startsWith('# '))
    .toList();

void main() {
  group('CookieFiles.merge — one file for yt-dlp, which reads only one', () {
    test('two platforms picked together both survive: the reason this '
        'exists, because yt-dlp reads a single cookies file', () {
      final merged = CookieFiles.merge([
        file([row('.youtube.com', 'SID', 'y1')]),
        file([row('.vimeo.com', 'vuid', 'v1')]),
      ]);

      expect(cookiesIn(merged), [
        row('.youtube.com', 'SID', 'y1'),
        row('.vimeo.com', 'vuid', 'v1'),
      ]);
      expect(utf8.decode(merged!), startsWith(CookieFiles.header));
    });

    test('#HttpOnly_ lines are cookies, not comments — dropping them would '
        'drop most sign-in cookies', () {
      final merged = CookieFiles.merge([
        file([row('#HttpOnly_.youtube.com', '__Secure-3PSID', 's')]),
      ]);

      expect(cookiesIn(merged), [
        row('#HttpOnly_.youtube.com', '__Secure-3PSID', 's'),
      ]);
    });

    test('the same cookie in two files is kept once, from the LATER file', () {
      final merged = CookieFiles.merge([
        file([row('.vimeo.com', 'vuid', 'old'), row('.vimeo.com', 'a', '1')]),
        file([row('.Vimeo.com', 'vuid', 'new')]),
      ]);

      expect(cookiesIn(merged), [
        row('.vimeo.com', 'a', '1'),
        row('.Vimeo.com', 'vuid', 'new'),
      ]);
    });

    test('the same name on another path is another cookie', () {
      final merged = CookieFiles.merge([
        file([
          row('.x.com', 'id', '1'),
          row('.x.com', 'id', '2', path: '/api'),
        ]),
      ]);

      expect(cookiesIn(merged), hasLength(2));
    });

    test('Windows line endings are read, and not carried into a value', () {
      final merged = CookieFiles.merge([
        utf8.encode(
          '${row('.x.com', 'a', '1')}\r\n${row('.x.com', 'b', '2')}\r\n',
        ),
      ]);

      expect(cookiesIn(merged), [
        row('.x.com', 'a', '1'),
        row('.x.com', 'b', '2'),
      ]);
    });

    test('a file with not one cookie in it — a JSON export — is refused, '
        'not sent to replace a working file', () {
      expect(CookieFiles.merge([utf8.encode('[{"name":"SID"}]')]), isNull);
      expect(CookieFiles.merge([file(const [])]), isNull);
    });

    test('the sites are named for the person reading: subdomains fold into '
        'their site, HttpOnly counts, a country second level keeps three '
        'labels, and the list is sorted and unique', () {
      final merged = CookieFiles.merge([
        file([
          row('.youtube.com', 'SID', '1'),
          row('#HttpOnly_accounts.google.com', 'LSID', '2'),
          row('.google.com', 'NID', '3'),
          row('www.bbc.co.uk', 'ckns', '4'),
          row('vimeo.com', 'vuid', '5'),
        ]),
      ])!;

      expect(CookieFiles.sites(merged), [
        'bbc.co.uk',
        'google.com',
        'vimeo.com',
        'youtube.com',
      ]);
    });

    test('a file with no cookie lines names no site', () {
      expect(CookieFiles.sites(utf8.encode('[{"name":"SID"}]')), isEmpty);
    });

    test('a bad line among good ones is skipped, not fatal', () {
      final merged = CookieFiles.merge([
        file(['not a cookie line', row('.x.com', 'a', '1')]),
      ]);

      expect(cookiesIn(merged), [row('.x.com', 'a', '1')]);
    });
  });

  group('CookieFiles.fromHeaders — the phone browser\'s cookies', () {
    test('each cookie of a header becomes a session cookie of the site', () {
      final bytes = CookieFiles.fromHeaders({
        'https://www.youtube.com/': 'SID=abc; HSID=def; LOGIN_INFO=g=h',
      });

      expect(cookiesIn(bytes), [
        '.youtube.com\tTRUE\t/\tTRUE\t\tSID\tabc',
        '.youtube.com\tTRUE\t/\tTRUE\t\tHSID\tdef',
        '.youtube.com\tTRUE\t/\tTRUE\t\tLOGIN_INFO\tg=h',
      ]);
      expect(utf8.decode(bytes!), startsWith(CookieFiles.header));
    });

    test('the expiry is empty, never 0: Python sends a session cookie and '
        'drops one that expired in 1970', () {
      final bytes = CookieFiles.fromHeaders({'https://x.com/': 'auth_token=t'});
      final fields = cookiesIn(bytes).single.split('\t');
      expect(fields, hasLength(7));
      expect(fields[4], isEmpty);
    });

    test('two pages of one site give the site once, the later value kept', () {
      final bytes = CookieFiles.fromHeaders({
        'https://accounts.google.com/': 'SID=old',
        'https://www.google.com/': 'SID=new; NID=n',
      });
      expect(cookiesIn(bytes), [
        '.google.com\tTRUE\t/\tTRUE\t\tSID\tnew',
        '.google.com\tTRUE\t/\tTRUE\t\tNID\tn',
      ]);
    });

    test('a page with no cookies, or none at all, gives null', () {
      expect(CookieFiles.fromHeaders({'https://x.com/': ''}), isNull);
      expect(CookieFiles.fromHeaders({'https://x.com/': '; ;'}), isNull);
      expect(CookieFiles.fromHeaders({}), isNull);
      expect(CookieFiles.fromHeaders({'not a url': 'a=b'}), isNull);
    });

    test('what it writes, merge and sites read back', () {
      final bytes = CookieFiles.fromHeaders({
        'https://www.youtube.com/': 'SID=abc',
        'https://www.instagram.com/': 'sessionid=s',
      });
      expect(CookieFiles.sites(bytes!), ['instagram.com', 'youtube.com']);
      final merged = CookieFiles.merge([
        file([row('.vimeo.com', 'vimeo', 'v')]),
        bytes,
      ]);
      expect(CookieFiles.sites(merged!), [
        'instagram.com',
        'vimeo.com',
        'youtube.com',
      ]);
    });
  });

  group('CookieFiles.names and without — one site at a time', () {
    final bytes = file([
      row('.youtube.com', 'SID', 'y1'),
      row('#HttpOnly_.youtube.com', 'LOGIN_INFO', 'l'),
      row('.vimeo.com', 'vimeo', 'v1'),
      row('accounts.google.com', 'SID', 'g'),
    ]);

    test('names are grouped by site, HttpOnly rows included', () {
      expect(CookieFiles.names(bytes), {
        'youtube.com': {'SID', 'LOGIN_INFO'},
        'vimeo.com': {'vimeo'},
        'google.com': {'SID'},
      });
    });

    test('without a site keeps the other sites as they were', () {
      final left = CookieFiles.without(bytes, 'youtube.com');
      expect(cookiesIn(left), [
        row('.vimeo.com', 'vimeo', 'v1'),
        row('accounts.google.com', 'SID', 'g'),
      ]);
    });

    test('without the last site is null, so the file goes', () {
      final only = file([row('.vimeo.com', 'vimeo', 'v1')]);
      expect(CookieFiles.without(only, 'vimeo.com'), isNull);
      expect(CookieFiles.without(only, 'x.com'), isNotNull);
    });
  });
}
