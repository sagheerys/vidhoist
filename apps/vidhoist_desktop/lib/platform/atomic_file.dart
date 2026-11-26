import 'dart:io';

/// What a file being written is called until it is whole.
const atomicTempSuffix = '.tmp';

/// Writes [text] to [path] through `<path>.tmp` and a rename. A crash or a
/// power cut in the middle leaves the earlier file whole (or no file),
/// never a truncated one under the real name: the rename is the only step
/// a reader can see, and Windows replaces the target in one move.
Future<File> writeAtomically(String path, String text) async {
  final temp = File('$path$atomicTempSuffix');
  await temp.writeAsString(text, flush: true);
  return temp.rename(path);
}

/// Removes what an interrupted [writeAtomically] left in [dir]: a file
/// that was never finished, which a user copying the folder would take.
Future<void> dropUnfinished(Directory dir) async {
  await for (final f in dir.list()) {
    if (f is! File || !f.path.endsWith(atomicTempSuffix)) continue;
    try {
      await f.delete();
    } on FileSystemException {
      // Left for the next time; it never carries the real name.
    }
  }
}
