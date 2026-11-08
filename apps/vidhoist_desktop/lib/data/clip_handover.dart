import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';

/// What a clip dragged out of the window becomes where it lands: its file
/// on this computer, handed over as it is.
class ClipHandover {
  const ClipHandover();

  /// The file on this computer, when it is really there; the index is not
  /// trusted, a file deleted in Explorer stays in it.
  String? localFile(LibraryItem item) {
    final path = item.localPath;
    return path != null && File(path).existsSync() ? path : null;
  }
}

final clipHandoverProvider = Provider((ref) => const ClipHandover());

/// How a clip in the library becomes something to drag out: Windows' drag
/// source in the app, nothing in tests, which have no native drag and drop.
typedef ClipDragBuilder = Widget Function(LibraryItem item, Widget child);

/// Overridden in main with the Windows drag source.
final clipDragProvider = Provider<ClipDragBuilder>(
  (ref) =>
      (item, child) => child,
);
