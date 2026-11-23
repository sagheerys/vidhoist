import 'dart:convert';

import '../constants/vh_constants.dart';
import '../resolvers/http_fetch.dart';
import '../urls/url_kit.dart';
import 'app_version.dart';
import 'release_note_translations.dart';
import 'update_release.dart';

/// Checking for updates through GitHub Releases.
///
/// It uses the same [HttpGetString] the platform resolvers use, so it
/// carries no header of anyone else's.
///
/// **Entirely fail-safe**: every error path returns `null`. No network, no
/// private repository and no unexpected JSON ever shows the user an error
/// during an automatic check. An update is a service, not a duty.
class UpdateChecker {
  UpdateChecker({
    required this.fetch,
    required this.assetMarker,
    this.assetExtension = '.apk',
    this.repo = VhConstants.updateRepo,
    this.trustedAsset = UpdateRelease.fromGitHub,
    this.abis = const [],
    this.notesApp,
  });

  /// Which app's part of the notes file to read: `phone` or `windows`.
  /// Without it the notes file is not fetched at all.
  final String? notesApp;

  /// The phone's ABIs, most preferred first (`Build.SUPPORTED_ABIS`), so a
  /// release split per ABI hands it the file built for it; empty takes the
  /// first file that matches.
  final List<String> abis;

  /// Where this app's file may be downloaded from: GitHub over https.
  /// Tests serve a file of their own.
  final bool Function(Uri link) trustedAsset;

  final HttpGetString fetch;

  /// The part of a filename that identifies this app's files
  /// (`vidhoist`).
  final String assetMarker;

  /// How this app's file ends: `.apk` on the phone, `.exe` on Windows.
  final String assetExtension;

  /// `owner/name`. The single switching point if releases ever move to a
  /// public repository separate from the code.
  final String repo;

  Uri get latestUri =>
      Uri.parse('https://api.github.com/repos/$repo/releases/latest');

  /// The public page of the release tagged for [version].
  String pageUrlOf(String version) =>
      'https://github.com/$repo/releases/tag/v$version';

  /// The notes of the release tagged for [version], or `null` on any
  /// failure. For "what's new" after an update the app did not download
  /// itself, from a browser or another device.
  Future<String?> notesFor(String version) async =>
      (await releaseNotesFor(version))?.notes;

  /// The page's notes of the release tagged for [version] and this app's
  /// notes file, or `null` when the page could not be read.
  Future<({String notes, Map<String, String> translations})?> releaseNotesFor(
    String version,
  ) async {
    try {
      final body = await fetch(
        Uri.parse('https://api.github.com/repos/$repo/releases/tags/v$version'),
      );
      final decoded = json.decode(body);
      if (decoded is! Map<String, dynamic>) return null;
      final notes = decoded['body'];
      if (notes is! String || notes.trim().isEmpty) return null;
      return (
        notes: notes,
        translations: await translationsAt(_notesUrlIn(decoded['assets'])),
      );
    } catch (_) {
      return null;
    }
  }

  /// This app's part of the notes file at [url]; empty on any failure, so
  /// the release page stands in.
  Future<Map<String, String>> translationsAt(String? url) async {
    final app = notesApp;
    final link = UrlKit.webUri(url);
    if (app == null || link == null || !trustedAsset(link)) return const {};
    try {
      final body = await fetch(link);
      if (body.length > vhNotesAssetCeiling) return const {};
      return vhParseNoteTranslations(body, app);
    } catch (_) {
      return const {};
    }
  }

  String? _notesUrlIn(Object? assets) {
    if (assets is! List) return null;
    for (final asset in assets) {
      if (asset is Map<String, dynamic> &&
          asset['name'] is String &&
          (asset['name'] as String).toLowerCase() == vhNotesAssetName &&
          asset['browser_download_url'] is String) {
        return asset['browser_download_url'] as String;
      }
    }
    return null;
  }

  /// Fail-safe: swallows every error and returns `null`. **For the
  /// automatic check**, which runs without the user's knowledge and must
  /// never interrupt them with an error.
  Future<UpdateRelease?> check({
    required String currentVersion,
    String? skippedVersion,
  }) async {
    try {
      return await checkOrThrow(
        currentVersion: currentVersion,
        skippedVersion: skippedVersion,
      );
    } catch (_) {
      return null;
    }
  }

  /// Throws when unreachable. **For the manual check only**: whoever
  /// pressed the button deserves to tell "you are on the latest version"
  /// apart from "GitHub could not be reached", and in [check] those are one
  /// result.
  ///
  /// Returns the available release if it is **genuinely newer** than
  /// [currentVersion], and `null` when there is nothing new.
  /// [skippedVersion] is what the user chose to skip; it stays muted while
  /// it is the newest, and returns with whatever follows it.
  Future<UpdateRelease?> checkOrThrow({
    required String currentVersion,
    String? skippedVersion,
  }) async {
    final current = AppVersion.tryParse(currentVersion);
    // **An unreadable local version means no check**: with no reference to
    // compare against, we could offer an "update" to something older than
    // what is installed.
    if (current == null) return null;

    final body = await fetch(latestUri);
    final release = UpdateRelease.tryParse(
      body,
      assetMarker: assetMarker,
      extension: assetExtension,
      trusted: trustedAsset,
      abis: abis,
    );
    if (release == null) return null;
    if (release.version <= current) return null;

    final skipped = AppVersion.tryParse(skippedVersion);
    if (skipped != null && release.version <= skipped) return null;
    // Read only for a release worth offering: the notes are shown in the
    // reader's language in the update sheet, and kept for "what's new".
    if (release.notesUrl == null) return release;
    return release.withTranslations(await translationsAt(release.notesUrl));
  }

  /// Is the automatic check due? Prevents a request at every launch.
  ///
  /// `null` in [lastCheck] means "never checked", so it checks immediately.
  static bool isDue(
    DateTime? lastCheck,
    DateTime now, {
    Duration interval = VhConstants.updateCheckInterval,
  }) {
    if (lastCheck == null) return true;
    // **The device clock can move backwards** (a timezone change, an NTP
    // sync): a check "in the future" must not freeze the feature forever.
    if (lastCheck.isAfter(now)) return true;
    return now.difference(lastCheck) >= interval;
  }
}
