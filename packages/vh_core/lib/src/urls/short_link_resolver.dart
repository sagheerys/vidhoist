import 'dart:io';

import '../constants/vh_constants.dart';
import 'url_kit.dart';

/// One step of redirect following: returns the next `Location` URL, or
/// null when there is no redirect. Injected for testing; the default
/// implementation is [ioRedirectStep].
typedef RedirectStep = Future<String?> Function(String url);

/// Resolves short links (vm./vt.tiktok, fb.watch, facebook /share/,
/// on.soundcloud) by following redirects, while **refusing an HTTPS to HTTP
/// downgrade**. On any failure or downgrade the
/// original URL is returned unchanged.
class ShortLinkResolver {
  ShortLinkResolver({RedirectStep? redirectStep})
    : _redirectStep = redirectStep ?? ioRedirectStep;

  final RedirectStep _redirectStep;

  Future<String> resolve(String url) async {
    if (!UrlKit.needsResolution(url)) return url;

    final origIsHttps = url.toLowerCase().startsWith('https://');
    var current = url;
    try {
      for (var hop = 0; hop < VhConstants.maxRedirectHops; hop++) {
        final next = await _redirectStep(current);
        if (next == null) break;
        current = Uri.parse(current).resolve(next).toString();
      }
    } catch (_) {
      // Unresolved, the link goes to yt-dlp as given: it follows most itself.
      return url;
    }

    final resolvedIsHttps = current.toLowerCase().startsWith('https://');
    if (origIsHttps && !resolvedIsHttps) return url;
    return current;
  }

  /// **Resolution with a time ceiling, for the routing decision before
  /// downloading** (2026-09-08).
  ///
  /// `on.soundcloud.com/…`, which is what the share button in the
  /// SoundCloud app produces, contains no `/sets/`, so `PlaylistDetector`
  /// saw a single clip and passed it to yt-dlp, which expanded
  /// it into a **whole album**: twenty tracks downloaded with no selection
  /// screen, while the app knew of one task. The decision has to be made on
  /// the **final** URL, not the entered one.
  ///
  /// The ceiling is necessary: this decision happens while the user waits,
  /// unlike resolution inside the engine, which runs after the task has
  /// already started.
  Future<String> resolveForRouting(String url) =>
      resolve(url)
          .timeout(VhConstants.routingResolveTimeout, onTimeout: () => url);

  /// A short link that may turn out to be a playlist once followed, so the
  /// choice between the sheet and the playlist screen waits for it. Of the
  /// short links, only SoundCloud's leads to one the app tells apart.
  static bool mayHidePlaylist(String url) =>
      UrlKit.needsResolution(url) &&
      url.toLowerCase().contains('on.soundcloud.com');
}

/// The default dart:io implementation: a GET with no automatic following,
/// reading the Location header only and closing the response without
/// pulling the body.
///
/// The body used to be drained: the last hop of a TikTok link is the video
/// page itself, some 440 KB (measured 2026-11-17), read whole on a phone's
/// connection while the share waited for the sheet.
Future<String?> ioRedirectStep(String url) async {
  final client = HttpClient()
    ..connectionTimeout = VhConstants.testConnectionTimeout;
  try {
    final request = await client.getUrl(Uri.parse(url));
    request.followRedirects = false;
    final response = await request.close();
    if (response.statusCode >= 300 && response.statusCode < 400) {
      return response.headers.value(HttpHeaders.locationHeader);
    }
    return null;
  } finally {
    client.close(force: true);
  }
}
