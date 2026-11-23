import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart' show vhShareWithNotice;
import 'package:share_plus/share_plus.dart';

import '../../di.dart';
import '../player/sidecar_subtitles.dart';
import '../settings/auto_backup.dart';
import 'download_wiring.dart';
import 'library_providers.dart';
import 'local_item.dart';
import 'media_remover.dart';

final libraryActionsProvider = Provider((ref) => LibraryActions(ref));

/// Actions on a local library item: the file on the
/// phone is everything, so there are no remote actions.
class LibraryActions {
  LibraryActions(this._ref);

  final Ref _ref;

  /// Favourites are a system tag under the item key, so they enter the
  /// backup automatically.
  Future<bool> toggleFavorite(String key) async {
    final tags = _ref.read(tagsIndexProvider);
    await tags.toggleTag(key, VhConstants.favoritesSystemTag);
    _ref.invalidate(localMediaProvider);
    await _ref.read(autoBackupProvider).requestBackup();
    return (await tags.tagsOf(key)).contains(VhConstants.favoritesSystemTag);
  }

  /// Deletes the files for good, cleans the indexes, and rescans the
  /// gallery so no trace of the deleted file is left in MediaStore.
  ///
  /// Files Android will not let the app delete by path (see
  /// [MediaRemover]) are put to the user in one system dialog. A clip
  /// still on the phone afterwards keeps everything the library knows
  /// about it, and the call ends in [DeleteRefusedException] so the
  /// screen does not announce a deletion that did not happen.
  Future<int> deleteFiles(List<LocalItem> items) async {
    final remover = _ref.read(mediaRemoverProvider);
    final refused = <String>[];
    for (final item in items) {
      // The subtitles fetched with a clip are of no use without it.
      final files = [File(item.path), ...sidecarSubtitleFiles(item.path)];
      for (final file in files) {
        if (!await remover.delete(file)) refused.add(file.path);
      }
    }
    if (refused.isNotEmpty) await remover.askSystem(refused);
    final gone = [
      for (final item in items)
        if (!await File(item.path).exists()) item,
    ];
    for (final item in gone) {
      final url = item.canonicalUrl;
      if (url != null) await _ref.read(offlineIndexProvider).removeKey(url);
      await _ref.read(titleIndexProvider).removeKey(item.key);
      // **Pruning the rest:** tags, positions and dimensions used
      // to stay forever in the same XML file that is re-serialised on every
      // write, and `exportToString` copies whole, so backups swelled with
      // corpses.
      await _ref.read(tagsIndexProvider).removeKey(item.key);
      await _ref.read(mediaShapeIndexProvider).removeKey(item.key);
      await _ref.read(playbackPositionsProvider).clear(item.key);
      await _ref.read(mediaStoreProvider).scanFile(item.path);
    }
    // The artwork step deletes **the thumbnail file itself** along with the
    // entry, in one pass, because the check "is another key using it?"
    // needs the whole picture.
    await _ref.read(artworkIndexProvider).removeKeysAndFiles([
      for (final item in gone) item.key,
    ]);
    await _ref.read(keptCoverIndexProvider).removeKeysAndFiles([
      for (final item in gone) item.key,
    ]);
    // **And the saved playlists**: every index was pruned except the
    // playlists, so a dead entry stayed and played something else when
    // tapped.
    await _ref.read(playlistsStoreProvider).removeFromAll([
      for (final item in gone) ...[item.key, item.path, ?item.canonicalUrl],
    ]);
    _ref.read(playlistsRevisionProvider.notifier).state++;
    _ref.invalidate(localMediaProvider);
    await _ref.read(autoBackupProvider).requestBackup();
    if (gone.length < items.length) {
      throw DeleteRefusedException(
        deleted: gone.length,
        left: items.length - gone.length,
      );
    }
    return gone.length;
  }

  /// Shares the file itself: nothing is downloaded, since everything here
  /// is local. [context] carries the notice shown while Android copies a
  /// large file before its share menu opens.
  Future<void> share(BuildContext context, List<LocalItem> items) async {
    final files = [
      for (final item in items)
        if (File(item.path).existsSync()) XFile(item.path),
    ];
    if (files.isEmpty || !context.mounted) return;
    await vhShareWithNotice(context, () => Share.shareXFiles(files));
  }
}
