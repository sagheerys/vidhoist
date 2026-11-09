/// The sites a person can sign in to from Settings › Accounts.
///
/// Each names the page its sign-in starts on, the pages whose cookies
/// yt-dlp then needs, and the one cookie that only a signed-in session
/// carries: that cookie, not the mere presence of a consent cookie, is
/// what "signed in" means on the screen and what ends the sign-in page.
enum LoginSite {
  youtube(
    'YouTube',
    'https://accounts.google.com/ServiceLogin?service=youtube'
        '&continue=https%3A%2F%2Fm.youtube.com%2F',
    ['https://www.youtube.com/', 'https://www.google.com/'],
    'SID',
  ),
  instagram('Instagram', 'https://www.instagram.com/accounts/login/', [
    'https://www.instagram.com/',
  ], 'sessionid'),
  facebook('Facebook', 'https://m.facebook.com/login/', [
    'https://www.facebook.com/',
  ], 'c_user'),
  tiktok('TikTok', 'https://www.tiktok.com/login', [
    'https://www.tiktok.com/',
  ], 'sessionid'),
  x('X', 'https://x.com/i/flow/login', ['https://x.com/'], 'auth_token'),
  vimeo('Vimeo', 'https://vimeo.com/log_in', ['https://vimeo.com/'], 'vimeo');

  const LoginSite(this.label, this.loginUrl, this.pages, this.sessionCookie);

  /// The name as the site writes it, the same in every language.
  final String label;

  /// Where the sign-in page opens.
  final String loginUrl;

  /// The pages whose cookies are read once signed in; the first names
  /// the site itself.
  final List<String> pages;

  /// The cookie a signed-in session has and a visitor has not.
  final String sessionCookie;

  /// The site as `CookieFiles.sites` names it (`youtube.com`).
  String get domain {
    final host = Uri.parse(pages.first).host;
    final labels = host.split('.');
    return labels.skip(labels.length - 2).join('.');
  }

  /// Whether a cookies file, read as `CookieFiles.names`, holds this
  /// site's signed-in session.
  bool signedInPer(Map<String, Set<String>> names) =>
      names[domain]?.contains(sessionCookie) ?? false;

  static LoginSite? byName(String name) {
    for (final site in values) {
      if (site.name == name) return site;
    }
    return null;
  }
}

/// A WebView's user agent, as a sign-in page accepts it.
///
/// Google refuses to sign in inside anything that calls itself a WebView
/// ("this browser or app may not be secure"), and Android's WebView does
/// so twice: the `; wv` token and the `Version/4.0` token no browser
/// carries. With both gone the string reads as the phone's Chrome, which
/// it in fact is. Anything else is left as it was, so a page sees the
/// phone's real Android and Chrome versions.
String browserUserAgent(String webViewAgent) => webViewAgent
    .replaceFirst('; wv', '')
    .replaceFirst(RegExp(r'\s*Version/\d+(\.\d+)*'), '')
    .replaceAll(RegExp(r'\s{2,}'), ' ')
    .trim();
