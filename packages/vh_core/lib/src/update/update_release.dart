import 'dart:convert';

import '../urls/url_kit.dart';
import 'app_version.dart';

/// A release published on GitHub, as read from `releases/latest`.
class UpdateRelease {
  const UpdateRelease({
    required this.version,
    required this.tag,
    required this.apkUrl,
    required this.apkSize,
    this.sha256,
    this.notes = '',
    this.pageUrl = '',
    this.publishedAt,
  });

  final AppVersion version;
  final String tag;

  /// The download URL of this app's file: the APK on the phone, the
  /// installer on Windows.
  final String apkUrl;

  /// The file size in bytes, or `0` when GitHub did not declare one.
  final int apkSize;

  /// The file's SHA-256 as GitHub records it at upload (lowercase hex), or
  /// `null` for a release that carries none. The download is checked
  /// against it, so a file changed on its way here is never installed.
  final String? sha256;

  /// The release notes, raw Markdown as written.
  final String notes;

  /// The release page, a manual fallback when installing inside the app is
  /// not possible.
  final String pageUrl;

  final DateTime? publishedAt;

  /// The size in megabytes for display, or `null` when unknown.
  double? get sizeMb => apkSize <= 0 ? null : apkSize / (1024 * 1024);

  /// Reads GitHub's response and picks the asset matching [assetMarker]
  /// whose name ends with [extension] (`.apk` on the phones, `.exe` for
  /// the Windows installer).
  ///
  /// **Every asset is optional.** The apps share one release stream, so a
  /// release may carry any subset of the phone APKs and the Windows
  /// installer; a release without this app's file is "no update",
  /// never an error.
  ///
  /// Returns `null` rather than throwing on any anomaly: a draft, a
  /// pre-release, a release with no APK for this app, or unexpected JSON.
  /// **An update check never troubles the user with an error** (rule 5: a
  /// new feature does not break what works).
  /// A link to GitHub itself over https: where a release's page and its
  /// files are (`https://github.com/<owner>/<repo>/releases/download/…`,
  /// measured on the published release; GitHub redirects the download
  /// to its own file host from there).
  static bool fromGitHub(Uri link) =>
      link.isScheme('https') && link.host == 'github.com';

  static UpdateRelease? tryParse(
    String body, {
    required String assetMarker,
    String extension = '.apk',
    bool Function(Uri link) trusted = fromGitHub,
    List<String> abis = const [],
  }) {
    Object? decoded;
    try {
      decoded = json.decode(body);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;

    // **Drafts and pre-releases are rejected here too**, even though
    // `releases/latest` excludes them: the same parser serves the full
    // `releases` list if the endpoint ever changes.
    if (decoded['draft'] == true || decoded['prerelease'] == true) return null;

    final tag = decoded['tag_name'];
    if (tag is! String) return null;
    final version = AppVersion.tryParse(tag);
    if (version == null) return null;

    final assets = decoded['assets'];
    if (assets is! List) return null;
    final marker = assetMarker.toLowerCase();
    final ending = extension.toLowerCase();
    final matching = <_Asset>[];
    for (final asset in assets) {
      if (asset is! Map<String, dynamic>) continue;
      final name = asset['name'];
      final url = asset['browser_download_url'];
      if (name is! String || url is! String) continue;
      // The file is downloaded and installed (run, on Windows) as it is,
      // so it comes from GitHub over https or not at all.
      final link = UrlKit.webUri(url);
      if (link == null || !trusted(link)) continue;
      final lower = name.toLowerCase();
      // **Matching on both the marker and the extension**: one release
      // carries every app's file, so without the marker a phone could
      // install another app's APK; and without the extension it could be handed
      // the Windows installer that shares the release, or Windows an APK.
      if (!lower.endsWith(ending) || !lower.contains(marker)) continue;
      final size = asset['size'];
      matching.add((
        name: lower,
        url: url,
        size: size is int ? size : 0,
        sha256: _sha256Of(asset['digest']),
      ));
    }
    final chosen = abis.isEmpty
        ? matching.firstOrNull
        : _forAbis(matching, abis);
    if (chosen == null) return null;
    return UpdateRelease(
      version: version,
      tag: tag,
      apkUrl: chosen.url,
      apkSize: chosen.size,
      sha256: chosen.sha256,
      notes: decoded['body'] is String ? decoded['body'] as String : '',
      pageUrl: switch (UrlKit.webUri(decoded['html_url']?.toString())) {
        final page? when fromGitHub(page) => page.toString(),
        _ => '',
      },
      publishedAt: decoded['published_at'] is String
          ? DateTime.tryParse(decoded['published_at'] as String)
          : null,
    );
  }

  /// Android's processor families, as `Build.SUPPORTED_ABIS` names them.
  static const knownAbis = [
    'arm64-v8a',
    'armeabi-v7a',
    'armeabi',
    'x86_64',
    'x86',
  ];

  /// An ABI as a whole word of a file name: `armeabi` is not found inside
  /// `armeabi-v7a`, nor `x86` inside `x86_64`.
  static bool _names(String name, String abi) =>
      RegExp('(^|[^a-z0-9])${RegExp.escape(abi.toLowerCase())}(?![a-z0-9_-])')
          .hasMatch(name);

  /// The file built for the phone's first ABI that has one, else a single
  /// file for every phone; never one built for a processor the phone lacks.
  static _Asset? _forAbis(List<_Asset> matching, List<String> abis) {
    for (final abi in abis) {
      for (final asset in matching) {
        if (_names(asset.name, abi)) return asset;
      }
    }
    for (final asset in matching) {
      if (!knownAbis.any((abi) => _names(asset.name, abi))) return asset;
    }
    return null;
  }

  /// `sha256:<64 hex>`, as GitHub's API writes an asset's digest.
  static String? _sha256Of(Object? digest) {
    if (digest is! String) return null;
    final match = _digestPattern.firstMatch(digest.trim());
    return match?.group(1)!.toLowerCase();
  }

  static final _digestPattern = RegExp(
    r'^sha256:([0-9a-f]{64})$',
    caseSensitive: false,
  );
}

typedef _Asset = ({String name, String url, int size, String? sha256});
