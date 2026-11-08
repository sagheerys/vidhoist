import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/clip_handover.dart';
import '../../data/file_copy.dart';

/// Copies [item]'s file to the clipboard, to be pasted into a chat, a mail
/// or a folder: the computer's own share, as the phone's share sheet is
/// the phone's. A clip whose file is gone says so.
Future<void> copyFileOf(BuildContext context, LibraryItem item) async {
  final l = context.vhl;
  final container = ProviderScope.containerOf(context, listen: false);
  void say(String message, [VhNoticeKind kind = VhNoticeKind.info]) {
    if (context.mounted) {
      showVhNotice(context, message: message, kind: kind);
    }
  }

  final path = container.read(clipHandoverProvider).localFile(item);
  if (path == null || !container.read(filesToClipboardProvider)([path])) {
    say(l.desktopCopyFileFailed, VhNoticeKind.failed);
    return;
  }
  final name = path.substring(path.lastIndexOf(r'\') + 1);
  say(
    l.desktopFileReadyToPaste(name, vhFormatSize(fileLength(path) ?? 0)),
    VhNoticeKind.done,
  );
}
