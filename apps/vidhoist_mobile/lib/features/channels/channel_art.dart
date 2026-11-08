import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:path_provider/path_provider.dart';

/// A channel's two pictures.
enum ChannelArtKind { avatar, banner }

/// **A followed channel's pictures, kept as files on the phone**, so the
/// page shows them with no network and does not fetch them at every
/// visit. Fetched once from the address the last check gave, again only
/// when that address changes, and deleted with the channel on unfollow.
class ChannelArt {
  ChannelArt({required this.root, Future<List<int>> Function(Uri uri)? fetch})
    : _fetch = fetch ?? _download;

  /// The app's own folder; the pictures go under `channel_art`.
  final Future<String> Function() root;
  final Future<List<int>> Function(Uri uri) _fetch;

  /// More than any avatar or banner; a page that big is not a picture.
  static const maxBytes = 4 * 1024 * 1024;

  Future<Directory> _dir(String id) async =>
      Directory('${await root()}/channel_art/${_safe(id)}');

  /// The picture as a file: the one for [url] once fetched, else whatever
  /// was kept before, else null (the page then draws the channel's
  /// letter). A fetch that fails is no error: the kept one, or none.
  Future<File?> file(String id, ChannelArtKind kind, String? url) async {
    try {
      final dir = await _dir(id);
      final kept = await _kept(dir, kind);
      if (url == null) return kept;
      final name = '${kind.name}-${_hash(url)}';
      final wanted = File('${dir.path}/$name');
      if (await wanted.exists()) return wanted;
      final List<int> bytes;
      try {
        bytes = await _fetch(Uri.parse(url));
      } on Object {
        return kept;
      }
      if (bytes.isEmpty || bytes.length > maxBytes) return kept;
      await dir.create(recursive: true);
      // Written beside, then renamed: a half-written file is never shown.
      final part = File('${wanted.path}.part');
      await part.writeAsBytes(bytes, flush: true);
      await part.rename(wanted.path);
      // By name: a listed path and a built one differ in their slashes.
      if (kept != null && kept.uri.pathSegments.last != name) {
        await kept.delete().catchError((_) => kept);
      }
      return wanted;
    } on Object {
      return null;
    }
  }

  /// Unfollowing forgets the pictures too; following again fetches them.
  Future<void> forget(String id) async {
    try {
      final dir = await _dir(id);
      if (await dir.exists()) await dir.delete(recursive: true);
    } on Object {
      // A folder left behind costs a few kilobytes, never a failed unfollow.
    }
  }

  static Future<File?> _kept(Directory dir, ChannelArtKind kind) async {
    if (!await dir.exists()) return null;
    await for (final e in dir.list()) {
      final name = e.uri.pathSegments.last;
      if (e is File &&
          name.startsWith('${kind.name}-') &&
          !name.endsWith('.part')) {
        return e;
      }
    }
    return null;
  }

  /// A channel id as a folder name: YouTube's are already safe, another
  /// site's may hold a slash.
  static String _safe(String id) =>
      id.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

  /// FNV-1a, stable across runs, unlike `String.hashCode`: the file's name
  /// says which address it came from.
  static String _hash(String text) {
    var h = 0x811c9dc5;
    for (final c in text.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xffffffff;
    }
    return h.toRadixString(16);
  }

  static Future<List<int>> _download(Uri uri) async {
    if (uri.scheme != 'https' && uri.scheme != 'http') {
      throw ArgumentError.value(uri, 'uri', 'not a web address');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.getUrl(uri);
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}', uri: uri);
      }
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 30))) {
        bytes.addAll(chunk);
        if (bytes.length > maxBytes) break;
      }
      return bytes;
    } finally {
      client.close(force: true);
    }
  }
}

final channelArtProvider = Provider<ChannelArt>(
  (ref) => ChannelArt(
    root: () async => (await getApplicationSupportDirectory()).path,
  ),
);

/// One picture of one channel, keyed by what makes it differ: a new
/// address from a check asks again, the same one is read from disk.
final channelArtFileProvider =
    FutureProvider.family<File?, (String, ChannelArtKind, String?)>(
      (ref, key) => ref.read(channelArtProvider).file(key.$1, key.$2, key.$3),
    );

/// The request for [sub]'s [kind] picture.
(String, ChannelArtKind, String?) channelArtKey(
  ChannelSubscription sub,
  ChannelArtKind kind,
) => (
  sub.id,
  kind,
  kind == ChannelArtKind.avatar ? sub.avatarUrl : sub.bannerUrl,
);
