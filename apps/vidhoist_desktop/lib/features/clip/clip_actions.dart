import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';

import '../../shell/open_web_link.dart';

import '../../data/engine_data.dart';
import '../../data/library_data.dart';
import '../../data/lists_data.dart';
import '../../di.dart';

/// What can be done to one clip, as the phone's item actions do it, with
/// this computer's indexes.
class ClipActions {
  ClipActions(this._ref);

  final Ref _ref;

  Future<void> toggleFavorite(String canonicalUrl) async {
    await _ref
        .read(tagsIndexProvider)
        .toggleTag(canonicalUrl, VhConstants.favoritesSystemTag);
    _ref.invalidate(libraryItemsProvider);
  }

  /// The clip on its own site, in the browser.
  Future<void> openOriginal(String canonicalUrl) => openWebLink(canonicalUrl);

  /// Deletes [item]'s file on this computer and its record, then forgets
  /// what was kept about the clip. A clip still playing stops first, or
  /// Windows refuses to delete a file held open; a refusal throws for the
  /// caller to say. A file already gone is still forgotten.
  Future<void> deleteFile(LibraryItem item) async {
    final url = item.canonicalUrl;
    final player = _ref.read(playerProvider);
    if (player.state.current?.canonicalUrl == url) await player.stop();
    final path = item.localPath;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
      final history = _ref.read(localHistoryStoreProvider);
      for (final entry in await history.entries()) {
        if (entry.path == path) await history.remove(entry.item.id);
      }
    }
    await _prune(url);
    _ref.invalidate(localLibraryProvider);
  }

  /// The phone's pruning rules: tags, cover, shape, position, offline
  /// entry and list lines go with the clip, so backups do not carry
  /// corpses. **A clip with another file on this computer stays**, with all
  /// of it; the path is checked on disk, not trusted.
  Future<void> _prune(String url) async {
    final local = await _ref.read(localHistoryStoreProvider).entries();
    for (final entry in local) {
      if (entry.item.canonicalUrl == url && await File(entry.path).exists()) {
        return;
      }
    }
    final offline = _ref.read(offlineIndexProvider);
    await _ref.read(artworkIndexProvider).removeKeysAndFiles([url]);
    await _ref.read(keptCoverIndexProvider).removeKeysAndFiles([url]);
    await _ref.read(tagsIndexProvider).removeKey(url);
    await _ref.read(mediaShapeIndexProvider).removeKey(url);
    await PlaybackPositionStore(
      store: _ref.read(keyValueStoreProvider),
      mutex: _ref.read(prefsMutexProvider),
    ).clear(url);
    await offline.removeKey(url);
    // And the saved lists, or the dead line stays and is skipped as broken
    // each time the list plays.
    await _ref.read(playlistsStoreProvider).removeFromAll([url]);
    _ref.invalidate(playlistsProvider);
  }
}

final clipActionsProvider = Provider((ref) => ClipActions(ref));
