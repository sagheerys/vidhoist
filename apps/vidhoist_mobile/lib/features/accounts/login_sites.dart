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
  // `ct0` too: yt-dlp sends it with every call X answers for a signed-in
  // person, and a sign-in kept before it arrived was refused.
  x(
    'X',
    'https://x.com/i/flow/login',
    ['https://x.com/'],
    'auth_token',
    alsoNeeded: ['ct0'],
  ),
  vimeo('Vimeo', 'https://vimeo.com/log_in', ['https://vimeo.com/'], 'vimeo'),
  // Asked 2026-11-18: Reddit refuses some posts to a visitor, and a
  // SoundCloud account reaches what a visitor cannot; yt-dlp reads these
  // two cookies for each.
  reddit('Reddit', 'https://www.reddit.com/login/', [
    'https://www.reddit.com/',
  ], 'reddit_session'),
  soundcloud('SoundCloud', 'https://soundcloud.com/signin', [
    'https://soundcloud.com/',
  ], 'oauth_token');

  const LoginSite(
    this.label,
    this.loginUrl,
    this.pages,
    this.sessionCookie, {
    this.alsoNeeded = const [],
  });

  /// The name as the site writes it, the same in every language.
  final String label;

  /// Where the sign-in page opens.
  final String loginUrl;

  /// The pages whose cookies are read once signed in; the first names
  /// the site itself.
  final List<String> pages;

  /// The cookie a signed-in session has and a visitor has not.
  final String sessionCookie;

  /// Cookies that come with the session and that downloads need as well;
  /// a sign-in is kept only once they are there.
  final List<String> alsoNeeded;

  /// The site as `CookieFiles.sites` names it (`youtube.com`).
  String get domain => _domainOf(pages.first);

  /// Every site its sign-in keeps cookies for: YouTube's are Google's too,
  /// and those are its own, not a file's, nor removable apart from it.
  Set<String> get domains => {for (final page in pages) _domainOf(page)};

  static String _domainOf(String page) {
    final labels = Uri.parse(page).host.split('.');
    return labels.skip(labels.length - 2).join('.');
  }

  /// Whether a cookies file, read as `CookieFiles.names`, holds this
  /// site's signed-in session.
  bool signedInPer(Map<String, Set<String>> names) =>
      names[domain]?.contains(sessionCookie) ?? false;

  /// Whether a cookies file holds everything downloads need from this
  /// site: the session and [alsoNeeded].
  bool readyPer(Map<String, Set<String>> names) =>
      signedInPer(names) && alsoNeeded.every(names[domain]!.contains);

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
