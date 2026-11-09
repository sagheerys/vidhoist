import 'dart:io';

import 'package:vh_core/vh_core.dart';

import '../downloads_library/local_item.dart';

/// **`Download/Vidhoist` becomes `Download/VidHoist`** (owner's request,
/// 2026-11-09), in two parts that each stand alone.
///
/// Android's shared storage ignores letter case, so both names already
/// open the same folder. What the case changes is the text: the library
/// keys favourites, titles, covers and each clip's link by the file's
/// path, and a scan of `VidHoist` yields paths that no longer match the
/// saved `Vidhoist` ones. [rewriteStoredPaths] fixes the saved text,
/// which is what keeps the data; [renameMediaFolder] fixes what a file
/// manager shows, and may fail without harm.

/// The parent of the media folder on the phone's own storage.
const _parent = '/storage/emulated/0/Download';

/// The folder's path in any spelling, as saved text: followed by a slash,
/// a quote (inside JSON) or the end, so `VidhoistOld` is left alone.
final _anySpelling = RegExp(
  '${RegExp.escape('$_parent/')}vidhoist(?=[/"]|\$)',
  caseSensitive: false,
);

/// Renames the folder on disk when it is spelled otherwise, and says what
/// happened, for the log; null when there was nothing to do.
///
/// Two steps through a spare name: renaming straight to a name that
/// differs only in case renames a folder onto itself, which the system
/// accepts and does nothing. If the second step fails the first is undone,
/// so the folder never stays under the spare name. Android refuses to
/// rename a folder holding files an earlier install left behind; the old
/// spelling then stays on disk, and the app works the same.
Future<String?> renameMediaFolder({String parent = _parent}) async {
  final Directory? old;
  try {
    old = await Directory(parent)
        .list(followLinks: false)
        .where((entity) => entity is Directory)
        .cast<Directory?>()
        .firstWhere(
          (dir) => _nameOf(dir!.path).toLowerCase() == 'vidhoist',
          orElse: () => null,
        );
  } on FileSystemException catch (e) {
    return 'media folder: cannot list ${e.osError?.message ?? e.message}';
  }
  if (old == null || _nameOf(old.path) == mediaFolderName) return null;

  final spare = '$parent/$mediaFolderName.renaming';
  final Directory moved;
  try {
    moved = await old.rename(spare);
  } on FileSystemException catch (e) {
    return 'media folder: kept ${_nameOf(old.path)} '
        '(${e.osError?.message ?? e.message})';
  }
  try {
    await moved.rename('$parent/$mediaFolderName');
    return 'media folder: renamed ${_nameOf(old.path)} to $mediaFolderName';
  } on FileSystemException catch (e) {
    await moved.rename(old.path);
    return 'media folder: kept ${_nameOf(old.path)}, undone '
        '(${e.osError?.message ?? e.message})';
  }
}

/// Rewrites every saved string that holds the folder's path in another
/// spelling, keys included; returns how many entries changed.
///
/// Every key, not a list of the indexes that hold paths: a list would miss
/// the next index to save one. The pattern is narrow enough that nothing
/// else matches. Run at every start, since it costs one pass over values
/// already in memory, and after a restore, which can bring back a backup
/// written before the rename.
Future<int> rewriteStoredPaths(KeyValueStore store, PrefsMutex mutex) =>
    mutex.run(() async {
      var changed = 0;
      for (final key in await store.keys()) {
        final value = await store.get(key);
        final newKey = _fix(key);
        Object? newValue = value;
        if (value is String) {
          newValue = _fix(value);
        } else if (value is List) {
          newValue = [for (final item in value) _fix(item.toString())];
        }
        final valueChanged = value is List
            ? !_sameList(value, newValue! as List<String>)
            : newValue != value;
        if (newKey == key && !valueChanged) continue;
        if (newKey != key) await store.remove(key);
        await _put(store, newKey, newValue);
        changed++;
      }
      return changed;
    });

String _fix(String text) =>
    text.contains(RegExp('vidhoist', caseSensitive: false))
    ? text.replaceAll(_anySpelling, phoneMediaDir)
    : text;

bool _sameList(List<Object?> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].toString() != b[i]) return false;
  }
  return true;
}

Future<void> _put(KeyValueStore store, String key, Object? value) async {
  switch (value) {
    case String():
      await store.setString(key, value);
    case List<String>():
      await store.setStringList(key, value);
    case bool():
      await store.setBool(key, value);
    case int():
      await store.setInt(key, value);
    case double():
      await store.setDouble(key, value);
  }
}

String _nameOf(String path) =>
    path.replaceAll(r'\', '/').split('/').lastWhere((part) => part.isNotEmpty);
