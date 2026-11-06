import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../data/library_data.dart';
import '../../router.dart';
import '../../shell/context_menu.dart';
import '../../shell/error_text.dart';
import '../lists/list_dialogs.dart';
import 'clip_actions.dart';

enum _ClipChoice { addToList, copyLink, openOriginal, delete }

/// The right-click menu of a clip's page, and its "More" button: the
/// actions that do not earn a button, in the phone's order, **deleting the
/// file last** and only here, behind a confirmation. A clip with no file
/// here is not offered it: there is nothing to delete.
Future<void> showClipMenu(
  BuildContext context,
  WidgetRef ref,
  Offset globalPosition,
  PlaylistItem item,
) async {
  final l = context.mtl;
  final listed = (ref.read(libraryItemsProvider).valueOrNull ?? const [])
      .where((i) => i.canonicalUrl == item.canonicalUrl)
      .firstOrNull;
  final choice = await showEmberMenu(context, globalPosition, [
    EmberMenuEntry(_ClipChoice.addToList, MTIcons.queue, l.addToPlaylist),
    EmberMenuEntry(_ClipChoice.copyLink, MTIcons.link, l.desktopCopyLink),
    EmberMenuEntry(
      _ClipChoice.openOriginal,
      MTIcons.external,
      l.openOriginalLink,
    ),
    if (listed != null && listed.isOffline) ...[
      const EmberMenuEntry.divider(),
      EmberMenuEntry(
        _ClipChoice.delete,
        MTIcons.trash,
        l.deleteVideo,
        danger: true,
      ),
    ],
  ]);
  if (choice == null || !context.mounted) return;
  final actions = ref.read(clipActionsProvider);
  switch (choice) {
    case _ClipChoice.addToList:
      await showAddToPlaylistDialog(context, item);
    case _ClipChoice.copyLink:
      await Clipboard.setData(ClipboardData(text: item.canonicalUrl));
      if (context.mounted) showMTNotice(context, message: l.desktopLinkCopied);
    case _ClipChoice.openOriginal:
      await actions.openOriginal(item.canonicalUrl);
    case _ClipChoice.delete:
      final sure = await showMTConfirm(
        context,
        title: l.deleteVideo,
        message: l.deleteVideoConfirm(mtName(item.title)),
        confirmLabel: l.delete,
        cancelLabel: l.cancel,
        destructive: true,
      );
      if (!sure || !context.mounted) return;
      final router = GoRouter.of(context);
      try {
        await actions.deleteFile(listed!);
      } on Object catch (e) {
        // Windows refused (a file held open): say why, and stay.
        if (context.mounted) {
          showMTNotice(
            context,
            message: errorText(l, e),
            kind: MTNoticeKind.failed,
          );
        }
        return;
      }
      if (!context.mounted) return;
      showMTNotice(context, message: l.deletedTitle(mtName(item.title)));
      router.go(EmberRoutes.library);
  }
}

/// Carries a right click anywhere inside [child] to [showClipMenu].
class ClipMenuArea extends ConsumerWidget {
  const ClipMenuArea({super.key, required this.item, required this.child});

  final PlaylistItem item;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    // Only the right click is caught here; left in, Flutter would offer a
    // screen reader a "tap" on the whole area that does nothing.
    excludeFromSemantics: true,
    onSecondaryTapUp: (d) =>
        unawaited(showClipMenu(context, ref, d.globalPosition, item)),
    child: child,
  );
}
