/// What went wrong, in the terms the app explains to the person.
enum YtDlpErrorKind {
  /// The site refused for now: too many requests from this address.
  rateLimited,

  /// The video is gone, private, or restricted to members.
  unavailable,

  /// The site wants a signed-in session: an age check, YouTube's "not a
  /// bot" check, or a post for followers. Cookies are the way through.
  signInRequired,

  /// Not offered in this country, or this address is blocked.
  geoBlocked,

  /// No extractor knows the link.
  unsupportedUrl,

  /// The height or codec asked for does not exist here; retried once at
  /// best (see [YtDlpError.retryAtBest]).
  formatUnavailable,

  /// The disk is full.
  diskFull,

  /// ffmpeg or ffprobe is missing, so the streams cannot be merged or
  /// converted.
  engineMissing,

  /// The network failed: no route, no name resolution, a timeout.
  network,

  /// A stretch that starts after the video ends, on a site that never said
  /// how long the video is: yt-dlp still exits 0, with a file of a few
  /// broken seconds (Instagram, measured 2026-11-18).
  clipPastEnd,

  /// Anything else; the message is shown as it is.
  failed,
}

/// A failed yt-dlp run, classified.
class YtDlpError implements Exception {
  const YtDlpError(this.kind, this.message, {this.extractor, this.length});

  final YtDlpErrorKind kind;

  /// The `ERROR:` lines, or the last thing printed when there were none.
  final String message;

  /// yt-dlp's name for the site, from `ERROR: [youtube] …`.
  final String? extractor;

  /// For [YtDlpErrorKind.clipPastEnd], the video's length as ffmpeg read
  /// it, when it said.
  final Duration? length;

  /// A height ceiling on a site that lists no heights is refused rather
  /// than ignored; the app tries again once with the best format.
  bool get retryAtBest => kind == YtDlpErrorKind.formatUnavailable;

  /// Whether this is how yt-dlp fails once a site has moved on without
  /// it: a page it can no longer read, a signature or challenge it cannot
  /// solve, a 403 on a stream, or its own "confirm you are on the latest
  /// version" plea. An update and one more try are worth it then; the
  /// app keeps those rare with a gap between attempts.
  bool get maybeStaleEngine => switch (kind) {
    YtDlpErrorKind.failed => _stale.hasMatch(message),
    // Formats missing altogether, not a height the site lacks.
    YtDlpErrorKind.formatUnavailable => _noFormats.hasMatch(message),
    _ => false,
  };

  static final _stale = RegExp(
    r'yt-dlp -U|latest version|Unable to extract|Failed to extract|'
    r'extraction failed|nsig|[Ss]ignature|player response|HTTP Error 403|'
    r'Please report this issue|JS challenge|JavaScript runtime',
  );
  static final _noFormats = RegExp(
    r'Only images are available|Some formats may be missing',
  );

  @override
  String toString() => 'YtDlpError(${kind.name}): $message';
}

/// Reads a failed run's stderr.
///
/// The order of the checks matters: "Private video. Sign in if you've
/// been granted access" is about the video, not about signing in, and
/// "not available in your country" is geography, not a missing video.
abstract final class ErrorClassifier {
  static final _rules = <(YtDlpErrorKind, RegExp)>[
    (YtDlpErrorKind.diskFull, _re(r'No space left|Errno 28|disk (is )?full')),
    (
      YtDlpErrorKind.engineMissing,
      _re(r'ffmpeg (is )?not (found|installed)|ffprobe and ffmpeg not found'),
    ),
    (
      YtDlpErrorKind.formatUnavailable,
      _re(r'Requested format is not available'),
    ),
    (YtDlpErrorKind.rateLimited, _re(r'HTTP Error 429|Too Many Requests')),
    (
      YtDlpErrorKind.geoBlocked,
      _re(
        r'available (in|from) your (country|region|location)|geo.?restrict|'
        r'Your IP address is blocked|blocked it in your country',
      ),
    ),
    (
      YtDlpErrorKind.unavailable,
      _re(
        r'Video unavailable|video is unavailable|Private video|'
        r'has been removed|members[- ]only|account .* terminated|'
        r'video is not available|HTTP Error 404|does not exist',
      ),
    ),
    (
      YtDlpErrorKind.signInRequired,
      _re(
        r'Sign in to confirm|login required|requires? (a )?log ?in|'
        r'use --cookies|account credentials|inappropriate for some users',
      ),
    ),
    (YtDlpErrorKind.unsupportedUrl, _re(r'Unsupported URL')),
    (
      YtDlpErrorKind.network,
      _re(
        // Android words a failed name lookup as "No address associated
        // with host" (errno 7), where Windows says getaddrinfo.
        r'getaddrinfo failed|Name or service not known|'
        r'No address associated with host|'
        r'Temporary failure in name resolution|Failed to resolve|'
        r'timed out|Connection (refused|reset)|Network is unreachable|'
        r'Unable to download webpage: HTTP Error 5\d\d|No route to host',
      ),
    ),
  ];

  static RegExp _re(String pattern) => RegExp(pattern, caseSensitive: false);

  static final _extractor = RegExp(r'^ERROR: \[([^\]]+)\]');

  static YtDlpError classify(String stderr) {
    final lines = stderr
        .split('\n')
        .map((l) => l.trimRight())
        .where((l) => l.isNotEmpty);
    final errors = lines.where((l) => l.startsWith('ERROR:')).toList();
    final message = errors.isNotEmpty
        ? errors.join('\n')
        : (lines.isEmpty ? '' : lines.last);
    final extractor = errors.isEmpty
        ? null
        : _extractor.firstMatch(errors.first)?.group(1);
    for (final (kind, pattern) in _rules) {
      if (pattern.hasMatch(message)) {
        return YtDlpError(kind, message, extractor: extractor);
      }
    }
    return YtDlpError(YtDlpErrorKind.failed, message, extractor: extractor);
  }

  /// The first sentence of a yt-dlp error, for a phone screen.
  ///
  /// yt-dlp writes several lines behind an `ERROR:` and an `[extractor]`
  /// tag, then often the video id ("ERROR: [youtube] abc: Video
  /// unavailable\n…"); only that first sentence says anything, and the
  /// bracketed tag is reordered to the far end of an Arabic line. Returns
  /// [raw] itself, trimmed, when stripping would leave nothing.
  static String reason(String raw) {
    final lines = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);
    if (lines.isEmpty) return raw.trim();
    final first = lines.first;
    final stripped = first
        .replaceFirst(_errorPrefix, '')
        .replaceFirst(_tagAndId, '')
        .trim();
    return stripped.isEmpty ? first : stripped;
  }

  static final _errorPrefix = RegExp(r'^ERROR:\s*', caseSensitive: false);
  static final _tagAndId = RegExp(r'^\[[^\]]+\]\s*([\w-]+:\s+)?');
}
