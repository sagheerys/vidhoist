/// Every fixed number and list the core uses; no network or download
/// number is written anywhere else.
abstract final class VhConstants {
  /// How long one short link may take to answer.
  static const Duration testConnectionTimeout = Duration(seconds: 10);

  /// **A text file read whole** (a dropped list of links): the cap refuses
  /// only a file that is not one.
  static const int maxTextFileBytes = 5 * 1024 * 1024;

  /// **How long short-link resolution may hold up a routing decision**
  /// (2026-09-08): deciding "playlist or single" waits on the
  /// network and the user waits with it, so past this limit the link is
  /// used as it is rather than freezing the interface.
  static const Duration routingResolveTimeout = Duration(seconds: 5);

  /// The most links one paste or drop sends together. A page of text can
  /// hold hundreds; past this the rest are left out, and the user is told
  /// how many, rather than a queue no one meant to make.
  static const int maxLinksPerAdd = 100;

  // Qualities (§2.2).
  static const List<String> qualityWireValues = [
    'best',
    '1080',
    '720',
    '480',
    '360',
    'audio',
  ];

  // Local files (§2.4 and §5.3).
  static const String phoneFolderName = 'Vidhoist';
  static const String superFolderName = 'Vidhoist';
  static const int filenameTitleMaxLength = 80;
  static const String defaultMediaExtension = 'mp4';

  // Classifying blocked-platform errors (§2.3).
  static const List<String> platformBlockedMarkers = [
    'login',
    'sign in',
    'cookie',
    'bot',
  ];

  // Short links (§4).
  static const int maxRedirectHops = 8;

  /// Favourites are a hidden system tag inside TagsIndex: they enter the
  /// backup automatically and never appear among the user's own tags.
  static const String favoritesSystemTag = '__favorites__';

  /// **A limit a person never meets and a screen can hold**: tags are a
  /// handful of words for sorting, and without a ceiling a stress test of a
  /// thousand tags made every row of chips a wall. Only the creating of a
  /// new one stops at it; tags that arrive from a backup or a sync are all
  /// kept.
  static const int maxTags = 50;

  /// A tag's name, in characters: a chip that long still fits a phone.
  static const int maxTagLength = 24;

  // `owner/name` for the releases repository. **The single switching
  // point.**
  //
  // The `releases/latest` endpoint requires a **public** repository: while
  // it is private GitHub answers 404, which is read as "no update" in
  // silence (fail-safe). To separate releases from the code, changing this
  // one line to an independent public releases repository is enough.

  /// `owner/name` for the releases repository. **The single switching
  /// point.**
  ///
  /// The `releases/latest` endpoint requires a **public** repository: while
  /// it is private GitHub answers 404, which is read as "no update" in
  /// silence (fail-safe). To separate releases from the code, changing this
  /// one line to an independent public releases repository is enough.
  static const String updateRepo = 'sagheerys/vidhoist';

  /// How often the automatic check runs. Checking at every launch floods
  /// GitHub for nothing, and releases arrive in weeks rather than hours.
  static const Duration updateCheckInterval = Duration(hours: 12);

  /// The update file's name in the app cache. Fixed, so the next download
  /// overwrites it instead of piling old APKs on the device.
  static const String updateApkFileName = 'update.apk';
}
