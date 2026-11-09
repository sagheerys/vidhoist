import 'dart:convert';

/// **Several cookies files, merged into the one yt-dlp reads.**
///
/// yt-dlp takes a single cookies file, so keeping Vimeo's sign-in beside
/// YouTube's takes one file that carries both. This builds it in memory
/// from files the user picked together; where it is kept is the caller's
/// choice.
///
/// The format is Netscape's: one cookie per line, seven tab-separated
/// fields, `#` for comments — **except `#HttpOnly_`**, which is a cookie
/// whose domain is marked HTTP-only, and which browsers' exporters write
/// for most sign-in cookies. Reading it as a comment would drop exactly
/// the cookies that matter.
abstract final class CookieFiles {
  static const header = '# Netscape HTTP Cookie File';
  static const _httpOnly = '#HttpOnly_';

  /// The merged file, or null when not one line of any file is a cookie:
  /// a JSON export or a random text file should be refused here, not kept
  /// in place of a working file.
  ///
  /// The same cookie (domain, path, name) in two files is kept once, **from
  /// the later file**, so re-picking a fresh export with an old one does
  /// not revive the old value.
  static List<int>? merge(List<List<int>> files) {
    final byKey = <String, String>{};
    for (final bytes in files) {
      final text = utf8.decode(bytes, allowMalformed: true);
      for (final raw in const LineSplitter().convert(text)) {
        final line = raw.trim();
        if (line.isEmpty) continue;
        if (line.startsWith('#') && !line.startsWith(_httpOnly)) continue;
        final fields = raw.trimLeft().split('\t');
        if (fields.length < 7) continue;
        final domain = fields[0].startsWith(_httpOnly)
            ? fields[0].substring(_httpOnly.length)
            : fields[0];
        final key = '${domain.toLowerCase()}\t${fields[2]}\t${fields[5]}';
        // Removed first so the later file's line also takes the later place.
        byKey
          ..remove(key)
          ..[key] = raw.trimLeft();
      }
    }
    if (byKey.isEmpty) return null;
    return utf8.encode('$header\n${byKey.values.join('\n')}\n');
  }

  /// **The sites a file carries cookies for**, so the screen can say what
  /// was sent: after picking two files, "Cookies sent for: vimeo.com ·
  /// youtube.com" is the only proof that both went in. Read at the moment
  /// of sending and kept nowhere.
  ///
  /// A cookie for `accounts.google.com` and one for `.google.com` are the
  /// same site to the person reading, so each host is cut to its last two
  /// labels — three when the last two look like a country's second level
  /// (`bbc.co.uk`, not `co.uk`).
  static List<String> sites(List<int> bytes) =>
      names(bytes).keys.toList()..sort();

  /// The cookie names each site has in the file, by site as [sites] names
  /// them: whether YouTube's sign-in is there is read off `SID`, not off
  /// the mere presence of a consent cookie.
  static Map<String, Set<String>> names(List<int> bytes) {
    final found = <String, Set<String>>{};
    for (final fields in _rows(bytes)) {
      final site = _site(fields[0]);
      if (site == null) continue;
      (found[site] ??= {}).add(fields[5]);
    }
    return found;
  }

  /// The file without the cookies of [site] (as [sites] names it), or null
  /// when nothing is left: signing out of one site keeps the others.
  static List<int>? without(List<int> bytes, String site) {
    final kept = [
      for (final fields in _rows(bytes))
        if (_site(fields[0]) != site) fields.join('\t'),
    ];
    if (kept.isEmpty) return null;
    return utf8.encode('$header\n${kept.join('\n')}\n');
  }

  /// **A browser's cookies, as yt-dlp reads them.** Android's `CookieManager`
  /// gives a page's cookies as one `Cookie:` header (`SID=a; HSID=b`), with
  /// no path, expiry or flags; each becomes a session cookie of the page's
  /// site (`.youtube.com`), secure, on `/`. The expiry field is left empty
  /// rather than `0`: Python reads an empty field as "session" and sends
  /// the cookie, where `0` is an expiry in 1970 and the cookie is dropped
  /// at the first request. Null when no header carried a cookie.
  static List<int>? fromHeaders(Map<String, String> headersByUrl) {
    final byKey = <String, String>{};
    for (final MapEntry(key: url, value: header) in headersByUrl.entries) {
      final site = _site(Uri.tryParse(url)?.host ?? '');
      if (site == null) continue;
      for (final pair in header.split(';')) {
        final at = pair.indexOf('=');
        if (at <= 0) continue;
        final name = pair.substring(0, at).trim();
        final value = pair.substring(at + 1).trim();
        if (name.isEmpty) continue;
        byKey['$site\t$name'] = '.$site\tTRUE\t/\tTRUE\t\t$name\t$value';
      }
    }
    if (byKey.isEmpty) return null;
    return utf8.encode('$header\n${byKey.values.join('\n')}\n');
  }

  /// The cookie rows of a file, each as its seven (or more) fields, with
  /// the `#HttpOnly_` prefix kept on the domain so [without] writes the
  /// row back as it was.
  static Iterable<List<String>> _rows(List<int> bytes) sync* {
    final text = utf8.decode(bytes, allowMalformed: true);
    for (final raw in const LineSplitter().convert(text)) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('#') && !line.startsWith(_httpOnly)) continue;
      final fields = raw.trimLeft().split('\t');
      if (fields.length < 7) continue;
      yield fields;
    }
  }

  /// A host's site: its last two labels, or three under a country's second
  /// level. Null for an empty host.
  static String? _site(String rawHost) {
    var host = rawHost;
    if (host.startsWith(_httpOnly)) host = host.substring(_httpOnly.length);
    final labels = host
        .toLowerCase()
        .split('.')
        .where((label) => label.isNotEmpty)
        .toList();
    if (labels.isEmpty) return null;
    final countrySecondLevel =
        labels.length >= 3 &&
        labels.last.length == 2 &&
        labels[labels.length - 2].length <= 3;
    final keep = countrySecondLevel ? 3 : 2;
    return labels
        .skip(labels.length < keep ? 0 : labels.length - keep)
        .join('.');
  }
}
