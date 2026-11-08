import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/folders_data.dart';
import '../../shell/context_menu.dart';
import '../../shell/error_text.dart';
import '../clip/clip_actions.dart';
import '../clip/tags_dialog.dart';
import '../lists/list_dialogs.dart';
import 'clip_keys.dart';
import 'copy_file.dart';

enum ItemChoice {
  play,
  playNext,
  readingRoom,
  favorite,
  copyLink,
  copyFile,
  showInFolder,
  openOriginal,
  addToList,
  tags,
  deleteLocal,
}

/// The right-click menu of a clip in the library, by its state. Playing
/// comes first, each with the key that does it on a chosen clip; then the
/// rest **in the order of the phone's actions sheet** so nothing has to be
/// learned twice: the phone's share is the link copied, its external
/// player the file shown in Explorer. Deleting comes last, apart and in
/// the error colour, behind a confirmation.
List<DesktopMenuEntry<ItemChoice>> itemMenuEntries(
  VhLocalizations l,
  LibraryItem item, {
  required bool hasFile,
}) {
  return [
    DesktopMenuEntry(
      ItemChoice.play,
      VhIcons.play,
      l.play,
      shortcut: ClipKeys.play,
    ),
    DesktopMenuEntry(
      ItemChoice.playNext,
      VhIcons.next,
      l.desktopPlayNext,
      shortcut: ClipKeys.playNext,
    ),
    DesktopMenuEntry(
      ItemChoice.readingRoom,
      VhIcons.reading,
      l.desktopReadingRoom,
      shortcut: ClipKeys.reading,
    ),
    DesktopMenuEntry(
      ItemChoice.favorite,
      item.favorite ? VhIcons.favoriteOn : VhIcons.favorite,
      item.favorite ? l.removeFromFavorites : l.addToFavorites,
      shortcut: ClipKeys.favorite,
    ),
    const DesktopMenuEntry.divider(),
    DesktopMenuEntry(
      ItemChoice.copyLink,
      VhIcons.link,
      l.desktopCopyLink,
      shortcut: ClipKeys.copyLink,
    ),
    if (hasFile)
      DesktopMenuEntry(
        ItemChoice.copyFile,
        VhIcons.copy,
        l.desktopCopyFile,
        shortcut: ClipKeys.copyFile,
      ),
    if (hasFile)
      DesktopMenuEntry(
        ItemChoice.showInFolder,
        VhIcons.folder,
        l.desktopShowInFolder,
      ),
    DesktopMenuEntry(
      ItemChoice.openOriginal,
      VhIcons.external,
      l.openOriginalLink,
    ),
    DesktopMenuEntry(ItemChoice.addToList, VhIcons.queue, l.addToPlaylist),
    DesktopMenuEntry(ItemChoice.tags, VhIcons.tags, l.tags),
    if (item.isOffline) ...[
      const DesktopMenuEntry.divider(),
      DesktopMenuEntry(
        ItemChoice.deleteLocal,
        VhIcons.trash,
        l.deleteVideo,
        danger: true,
      ),
    ],
  ];
}

/// [onPlay] plays as a double click on the clip would: the list on screen
/// from it.
Future<void> showItemMenu(
  BuildContext context,
  WidgetRef ref,
  Offset globalPosition,
  LibraryItem item, {
  required VoidCallback onPlay,
}) async {
  final l = context.vhl;
  final file = item.localPath;
  final hasFile = file != null && File(file).existsSync();
  final choice = await showEmberMenu(
    context,
    globalPosition,
    itemMenuEntries(l, item, hasFile: hasFile),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case ItemChoice.play:
      onPlay();
    case ItemChoice.playNext:
      await playNextOf(context, ref, item);
    case ItemChoice.readingRoom:
      openReadingOf(context, item.canonicalUrl);
    case ItemChoice.favorite:
      await ref.read(clipActionsProvider).toggleFavorite(item.canonicalUrl);
    case ItemChoice.copyLink:
      await copyLinkOf(context, item.canonicalUrl);
    case ItemChoice.copyFile:
      await copyFileOf(context, item);
    case ItemChoice.showInFolder:
      if (file != null) await ref.read(desktopFoldersProvider).reveal(file);
    case ItemChoice.openOriginal:
      await ref.read(clipActionsProvider).openOriginal(item.canonicalUrl);
    case ItemChoice.addToList:
      await showAddToPlaylistDialog(context, toPlaylistItem(item));
    case ItemChoice.tags:
      await showTagsDialog(context, item.canonicalUrl);
    case ItemChoice.deleteLocal:
      final sure = await _sure(
        context,
        l.deleteVideo,
        l.deleteVideoConfirm(vhName(item.title)),
      );
      if (!sure || !context.mounted) return;
      try {
        await ref.read(clipActionsProvider).deleteFile(item);
      } on Object catch (e) {
        if (context.mounted) {
          showVhNotice(
            context,
            message: errorText(l, e),
            kind: VhNoticeKind.failed,
          );
        }
        return;
      }
      if (context.mounted) {
        showVhNotice(context, message: l.deletedTitle(vhName(item.title)));
      }
  }
}

Future<bool> _sure(BuildContext context, String title, String message) {
  final l = context.vhl;
  return showVhConfirm(
    context,
    title: title,
    message: message,
    confirmLabel: l.delete,
    cancelLabel: l.cancel,
    destructive: true,
  );
}
