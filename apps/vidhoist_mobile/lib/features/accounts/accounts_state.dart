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

/// The sites signed in, read off the cookies file each time it changes:
/// the file is the truth, so a file written by yt-dlp itself (it writes
/// its jar back after a run) reads the same. Read in one go: the file is
/// a few lines, and a loading state for it would only flicker the rows.
final signedInSitesProvider = Provider<Set<LoginSite>>((ref) {
  final path = ref.watch(cookiesFileProvider);
  if (path == null) return const {};
  try {
    final file = File(path);
    if (!file.existsSync()) return const {};
    final names = CookieFiles.names(file.readAsBytesSync());
    return {
      for (final site in LoginSite.values)
        if (site.signedInPer(names)) site,
    };
  } on FileSystemException {
    return const {};
  }
});

/// The sign-ins, or null where nothing can be kept.
final accountsProvider = Provider<Accounts?>((ref) {
  final path = ref.watch(cookiesFileProvider);
  if (path == null) return null;
  return Accounts(
    path: path,
    jar: ref.watch(webCookieJarProvider),
    onChanged: () => ref.invalidate(signedInSitesProvider),
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
  /// signed-in session for the site yet.
  Future<bool> keep(LoginSite site) async {
    final fresh = CookieFiles.fromHeaders(await jar.headers(site.pages));
    if (fresh == null || !site.signedInPer(CookieFiles.names(fresh))) {
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

  /// Whether the browser already holds a signed-in session for [site],
  /// without keeping anything.
  Future<bool> signedInBrowser(LoginSite site) async {
    final fresh = CookieFiles.fromHeaders(await jar.headers(site.pages));
    return fresh != null && site.signedInPer(CookieFiles.names(fresh));
  }

  /// Drops [site]'s rows from the file, and the browser's session with
  /// them; the file goes when nothing is left in it.
  Future<void> forget(LoginSite site) async {
    final file = File(path);
    if (file.existsSync()) {
      final left = CookieFiles.without(file.readAsBytesSync(), site.domain);
      if (left == null) {
        _delete(file);
      } else {
        file.writeAsBytesSync(left, flush: true);
      }
    }
    await jar.clear();
    onChanged();
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
