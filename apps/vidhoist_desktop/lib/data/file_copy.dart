import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Puts files on the clipboard as files; overridden in main with
/// Windows' own, false (nothing copied) in tests that do not say.
final filesToClipboardProvider = Provider<bool Function(List<String> paths)>(
  (ref) =>
      (_) => false,
);

/// A file's length, or null when there is no such file.
int? fileLength(String path) {
  final file = File(path);
  return file.existsSync() ? file.lengthSync() : null;
}
