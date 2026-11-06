import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'engine_data.dart';
import 'folders_data.dart';

/// How long the folder must be quiet before the library is read again: a
/// move in Explorer is several events, and one rebuild is enough.
const folderWatchQuiet = Duration(milliseconds: 600);

/// What yt-dlp writes while a download runs; a change to one says nothing
/// about the library, and it changes many times a second.
bool isPartialFile(String path) {
  final name = path.toLowerCase();
  return name.endsWith('.part') ||
      name.endsWith('.ytdl') ||
      name.endsWith('.temp') ||
      name.contains('.part-frag');
}

/// **The library keeps up with the download folder by itself**, watched by
/// the shell: a clip deleted, renamed or moved in Explorer leaves the
/// library or comes back without a button. A finished download needs no
/// event: the engine already says so.
final folderWatchProvider = Provider<void>((ref) {
  final folder = ref.watch(downloadFolderProvider).valueOrNull;
  if (folder == null) return;
  final dir = Directory(folder);
  Timer? quiet;
  StreamSubscription<FileSystemEvent>? watching;
  try {
    // Made now rather than at the first download, so it is watched from
    // the start.
    dir.createSync(recursive: true);
    watching = dir.watch(recursive: true).listen(
      (event) {
        if (isPartialFile(event.path)) return;
        quiet?.cancel();
        quiet = Timer(
          folderWatchQuiet,
          () => ref.invalidate(localLibraryProvider),
        );
      },
      // A folder on a drive that went away: the library stays as it
      // was, and the next start watches again.
      onError: (Object _) {},
    );
  } on FileSystemException {
    return;
  }
  ref.onDispose(() {
    quiet?.cancel();
    watching?.cancel();
  });
});
