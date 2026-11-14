import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import 'cookie_jar.dart';
import 'login_sites.dart';

/// Where the cookies file yt-dlp reads is kept: the app's private support
/// folder, which no backup and no other app reads. Null where there is no
/// disk (tests), and then nothing is kept and no site is signed in.
final cookiesFileProvider = Provider<String?>((ref) => null);

final webCookieJarProvider = Provider<WebCookieJar>(
  (ref) => const MethodChannelWebCookieJar(),
);

/// The cookie names each site has in the cookies file, read off it each
/// time it changes: the file is the truth, so a file written by yt-dlp
/// itself (it writes its jar back after a run) reads the same. Read in one
/// go: the file is a few lines, and a loading state for it would only
/// flicker the rows.
final cookieNamesProvider = Provider<Map<String, Set<String>>>((ref) {
  final path = ref.watch(cookiesFileProvider);
  if (path == null) return const {};
  try {
    final file = File(path);
    if (!file.existsSync()) return const {};
    return CookieFiles.names(file.readAsBytesSync());
  } on FileSystemException {
    return const {};
  }
});

/// The sites signed in, from a sign-in here or from an imported file.
final signedInSitesProvider = Provider<Set<LoginSite>>((ref) {
  final names = ref.watch(cookieNamesProvider);
  return {
    for (final site in LoginSite.values)
      if (site.signedInPer(names)) site,
  };
});

/// The sites an imported file brought that have no row of their own: a
/// file exported from a browser carries whatever sites it was signed in
/// to, and each must be seen to be removable.
final fileOnlySitesProvider = Provider<List<String>>((ref) {
  final listed = {for (final site in LoginSite.values) site.domain};
  return [
    for (final site in ref.watch(cookieNamesProvider).keys)
      if (!listed.contains(site)) site,
  ]..sort();
});

/// The sign-ins, or null where nothing can be kept.
final accountsProvider = Provider<Accounts?>((ref) {
  final path = ref.watch(cookiesFileProvider);
  if (path == null) return null;
  return Accounts(
    path: path,
    jar: ref.watch(webCookieJarProvider),
    onChanged: () => ref.invalidate(cookieNamesProvider),
  );
});

/// Keeps a site's sign-in for yt-dlp, and forgets it again.
///
/// The in-app browser holds every site in one jar, so forgetting one site
/// signs the browser out of all of them; the other sites' rows stay in the
/// file, and their downloads go on. Without that, "sign out" followed by
/// "sign in" would find the browser still signed in and keep the same
/// session again.
///
/// The file is written and read in one go: it is a few lines, touched when
/// a person signs in or out, and a screen must not wait on it.
class Accounts {
  Accounts({required this.path, required this.jar, required this.onChanged});

  final String path;
  final WebCookieJar jar;
  final void Function() onChanged;

  /// Reads [site]'s cookies from the browser and keeps them beside the
  /// other sites'. False, and nothing written, when the browser has no
  /// signed-in session for the site yet, or not all of it
  /// ([LoginSite.alsoNeeded]).
  Future<bool> keep(LoginSite site) async {
    final fresh = CookieFiles.fromHeaders(await jar.headers(site.pages));
    if (fresh == null || !site.readyPer(CookieFiles.names(fresh))) {
      return false;
    }
    final file = File(path);
    final old = file.existsSync() ? file.readAsBytesSync() : null;
    final merged = CookieFiles.merge([?old, fresh]);
    if (merged == null) return false;
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(merged, flush: true);
    onChanged();
    return true;
  }

  /// **A cookies file the person exported from a browser** (Netscape's
  /// format, `cookies.txt`), merged over what is kept: for someone who
  /// would rather not sign in inside the app, or for a site with no row.
  /// The sites it carried, or null, and nothing written, when it holds no
  /// cookie at all: a JSON export or a random text file must not replace
  /// a working file.
  Future<List<String>?> importFile(List<int> picked) async {
    final fresh = CookieFiles.merge([picked]);
    if (fresh == null) return null;
    final file = File(path);
    final old = file.existsSync() ? file.readAsBytesSync() : null;
    final merged = CookieFiles.merge([?old, fresh])!;
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(merged, flush: true);
    onChanged();
    return CookieFiles.sites(fresh);
  }

  /// Drops [site]'s rows (as `CookieFiles.sites` names it) and leaves the
  /// browser alone: what a file brought, the browser never held.
  Future<void> forgetSite(String site) async {
    _drop(site);
    onChanged();
  }

  /// Whether the browser already holds a signed-in session for [site],
  /// without keeping anything.
  Future<bool> signedInBrowser(LoginSite site) async {
    final fresh = CookieFiles.fromHeaders(await jar.headers(site.pages));
    return fresh != null && site.signedInPer(CookieFiles.names(fresh));
  }

  /// Drops [site]'s rows from the file, and the browser's session with
  /// them; the file goes when nothing is left in it.
  Future<void> forget(LoginSite site) async {
    _drop(site.domain);
    await jar.clear();
    onChanged();
  }

  void _drop(String site) {
    final file = File(path);
    if (!file.existsSync()) return;
    final left = CookieFiles.without(file.readAsBytesSync(), site);
    if (left == null) {
      _delete(file);
    } else {
      file.writeAsBytesSync(left, flush: true);
    }
  }

  /// Every sign-in goes: the file and the browser's jar.
  Future<void> forgetAll() async {
    _delete(File(path));
    await jar.clear();
    onChanged();
  }

  static void _delete(File file) {
    try {
      file.deleteSync();
    } on FileSystemException {
      // Already gone.
    }
  }
}
