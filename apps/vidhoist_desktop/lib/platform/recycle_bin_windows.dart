import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../data/clip_delete.dart';

/// Puts [path] in Windows' Recycle Bin, as Explorer's Delete does, so the
/// user can get it back. **A drive with no Recycle Bin is left alone**
/// (a network share, some memory sticks): Windows would quietly delete
/// for good there, so the caller decides instead.
Recycled recycleWithWindows(String path) {
  if (!_hasBin(path)) return Recycled.noBin;
  // SHFileOperation takes a list of names, each ended, the list ended twice.
  final from = '$path\u0000'.toNativeUtf16();
  final op = calloc<SHFILEOPSTRUCT>();
  try {
    op.ref
      ..wFunc = FO_DELETE
      ..pFrom = from
      // No dialog of Windows' own: the app asked already, and a dialog
      // from a phone's request would wait for someone at the computer.
      ..fFlags =
          FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_SILENT | FOF_NOERRORUI;
    final result = SHFileOperation(op);
    return result == 0 && op.ref.fAnyOperationsAborted == 0
        ? Recycled.done
        : Recycled.refused;
  } finally {
    calloc.free(from);
    calloc.free(op);
  }
}

/// Whether the drive [path] is on keeps a Recycle Bin: Windows answers for
/// a drive's root, and fails for one without.
bool _hasBin(String path) {
  final root = _rootOf(path);
  if (root == null) return false;
  final name = root.toNativeUtf16();
  final info = calloc<SHQUERYRBINFO>()..ref.cbSize = sizeOf<SHQUERYRBINFO>();
  try {
    return SHQueryRecycleBin(name, info) == S_OK;
  } finally {
    calloc.free(name);
    calloc.free(info);
  }
}

/// `C:\` for `C:\Users\…`; null for a share (`\\server\…`), which keeps
/// none.
String? _rootOf(String path) {
  final match = RegExp(r'^([A-Za-z]:)[\\/]').firstMatch(path);
  return match == null ? null : '${match.group(1)}\\';
}
