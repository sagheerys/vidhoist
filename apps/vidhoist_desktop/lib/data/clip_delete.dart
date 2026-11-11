import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';

import '../di.dart';
import 'engine_data.dart';
import 'library_data.dart';
import 'lists_data.dart';

/// What became of a file sent to the Recycle Bin.
enum Recycled {
  done,

  /// Its drive keeps no Recycle Bin; the file is untouched.
  noBin,

  /// Windows would not, as for a file another program holds open.
  refused,
}

/// Sends a file to the Recycle Bin: Windows' own in main; in tests a plain
/// delete that says it recycled.
final recycleFileProvider = Provider<Recycled Function(String path)>(
  (ref) => (path) {
    File(path).deleteSync();
    return Recycled.done;
  },
);

/// The clip's drive has no Recycle Bin, and the request came from a phone:
/// there it would be gone for good, so it stays.
class NoRecycleBinException implements Exception {
  const NoRecycleBinException();
}

/// Windows refused to recycle the file, as for one held open elsewhere.
class RecycleRefusedException implements Exception {
  const RecycleRefusedException();
}

/// **Deletes [item]'s file to the Recycle Bin** and its record, then
/// forgets what was kept about the clip. A clip still playing stops first,
/// or Windows refuses a file held open. A file already gone is still
/// forgotten.
///
/// On a drive with no Recycle Bin the owner's own delete, asked for here,
/// goes through for good as it always did; one from a phone
/// ([fromPhone]) throws [NoRecycleBinException] and touches nothing.
Future<void> deleteClipFile(
  Ref ref,
  LibraryItem item, {
  bool fromPhone = false,
}) async {
  final url = item.canonicalUrl;
  final player = ref.read(playerProvider);
  if (player.state.current?.canonicalUrl == url) await player.stop();
  final path = item.localPath;
  if (path != null) {
    final file = File(path);
    if (await file.exists()) {
      switch (ref.read(recycleFileProvider)(path)) {
        case Recycled.done:
          break;
        case Recycled.noBin when fromPhone:
          throw const NoRecycleBinException();
        case Recycled.noBin:
          await file.delete();
        case Recycled.refused:
          throw const RecycleRefusedException();
      }
    }
    final history = ref.read(localHistoryStoreProvider);
    for (final entry in await history.entries()) {
      if (entry.path == path) await history.remove(entry.item.id);
    }
  }
  await _prune(ref, url);
  ref.invalidate(localLibraryProvider);
}

/// The phone's pruning rules: tags, cover, shape, position, offline entry
/// and list lines go with the clip, so backups do not carry corpses. **A
/// clip with another file on this computer stays**, with all of it; the
/// path is checked on disk, not trusted.
Future<void> _prune(Ref ref, String url) async {
  final local = await ref.read(localHistoryStoreProvider).entries();
  for (final entry in local) {
    if (entry.item.canonicalUrl == url && await File(entry.path).exists()) {
      return;
    }
  }
  final offline = ref.read(offlineIndexProvider);
  await ref.read(artworkIndexProvider).removeKeysAndFiles([url]);
  await ref.read(keptCoverIndexProvider).removeKeysAndFiles([url]);
  await ref.read(tagsIndexProvider).removeKey(url);
  await ref.read(mediaShapeIndexProvider).removeKey(url);
  await PlaybackPositionStore(
    store: ref.read(keyValueStoreProvider),
    mutex: ref.read(prefsMutexProvider),
  ).clear(url);
  await offline.removeKey(url);
  // And the saved lists, or the dead line stays and is skipped as broken
  // each time the list plays.
  await ref.read(playlistsStoreProvider).removeFromAll([url]);
  ref.invalidate(playlistsProvider);
}
