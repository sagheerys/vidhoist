import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import 'playlists_providers.dart';

/// The naming dialog, used for creating, for renaming, and for saving a
/// playback session.
Future<String?> promptPlaylistName(
  BuildContext context, {
  String? initialName,
  String? title,
}) {
  final l10n = context.vhl;
  // The dialog owns the controller and disposes it; see
  // `vh_text_prompt.dart` in vh_ui.
  return promptVhText(
    context,
    title: title ?? l10n.createPlaylist,
    confirmLabel: initialName == null ? l10n.create : l10n.rename,
    initialValue: initialName,
    labelText: l10n.playlistName,
    hintText: l10n.playlistNameHint,
  );
}

Future<void> showCreatePlaylistDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final name = await promptPlaylistName(context);
  if (name == null || name.isEmpty) return;
  await ref.read(playlistsStoreProvider).create(name);
  ref.invalidate(playlistsProvider);
  if (context.mounted) {
    showVhSnack(
      context,
      context.vhl.playlistCreated,
      type: VhSnackType.success,
    );
  }
}

/// A long press on a playlist card: pin, edit, delete.
void showPlaylistActionsSheet(
  BuildContext context,
  WidgetRef ref,
  SavedPlaylist playlist,
) {
  final l10n = context.vhl;
  final p = VhThemeX.of(context).palette;
  final store = ref.read(playlistsStoreProvider);

  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VhSpace.xl,
              VhSpace.lg,
              VhSpace.xl,
              VhSpace.sm,
            ),
            child: Text(
              playlist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          ListTile(
            leading: VhIcon(
              playlist.pinned ? VhIcons.pinOn : VhIcons.pin,
              color: p.ink2,
            ),
            title: Text(
              playlist.pinned ? l10n.unpinPlaylist : l10n.pinPlaylist,
            ),
            onTap: () async {
              Navigator.pop(sheetContext);
              await store.setPinned(playlist.id, !playlist.pinned);
              ref.invalidate(playlistsProvider);
            },
          ),
          ListTile(
            leading: VhIcon(VhIcons.edit, color: p.ink2),
            title: Text(l10n.rename),
            onTap: () async {
              Navigator.pop(sheetContext);
              if (!context.mounted) return;
              final name = await promptPlaylistName(
                context,
                initialName: playlist.name,
                title: l10n.rename,
              );
              if (name == null || name.isEmpty) return;
              await store.rename(playlist.id, name);
              ref.invalidate(playlistsProvider);
            },
          ),
          // **Removing dead entries with one tap**: deleted files used to
          // stay in the playlist. Deleting from inside the app now prunes the
          // playlists automatically, and this cures what accumulated before
          // that, or what was deleted from outside the app.
          // `read` rather than `watch`: this is a function, not a `build`,
          // and `WidgetRef.watch` outside a build throws at runtime where
          // the analyser cannot catch it.
          if (ref.read(playlistViewProvider(playlist.id)).valueOrNull
              case final PlaylistView view when view.missing.isNotEmpty)
            ListTile(
              leading: VhIcon(VhIcons.queueRemove, color: p.ink2),
              title: Text(l10n.removeUnavailable(view.missing.length)),
              onTap: () async {
                Navigator.pop(sheetContext);
                for (final key in view.missing) {
                  await store.removeItem(playlist.id, key);
                }
                ref.invalidate(playlistViewProvider(playlist.id));
                ref.invalidate(playlistItemsProvider(playlist.id));
                ref.invalidate(playlistsProvider);
              },
            ),
          const Divider(),
          ListTile(
            leading: VhIcon(VhIcons.trash, color: p.err),
            title: Text(
              l10n.delete,
              style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(color: p.err),
            ),
            onTap: () async {
              Navigator.pop(sheetContext);
              if (!context.mounted) return;
              final ok = await _confirmDelete(context, playlist.name);
              if (!ok) return;
              await store.delete(playlist.id);
              ref.invalidate(playlistsProvider);
              if (context.mounted) {
                showVhSnack(context, l10n.playlistDeleted);
              }
            },
          ),
          const SizedBox(height: VhSpace.md),
        ],
      ),
    ),
  );
}

Future<bool> _confirmDelete(BuildContext context, String name) async {
  final l10n = context.vhl;
  final result = await showVhDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      content: Text(l10n.deletePlaylistConfirm(vhName(name))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}
