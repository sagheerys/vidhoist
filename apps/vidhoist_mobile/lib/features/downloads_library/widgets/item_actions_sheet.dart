import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../playlists/add_to_playlist_sheet.dart';
import '../../shared/error_report.dart';
import '../../shared/external_player.dart';
import '../artwork_view.dart';
import '../library_actions.dart';
import '../library_providers.dart';
import '../local_item.dart';
import 'item_details_sheet.dart';
import '../../shared/open_web_link.dart';

/// The item actions sheet (everything here is local). Delete
/// comes last, isolated by a divider and in the error
/// colour, which is a general navigation rule.
void showItemActionsSheet(BuildContext context, WidgetRef ref, LocalItem item) {
  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    // As tall as its rows, not the default nine sixteenths of the screen,
    // which hid Delete below a scroll once the menu grew a row. It still
    // scrolls on a phone too short for all of them.
    isScrollControlled: true,
    useSafeArea: true,
    // The screen's context, not the sheet's, is passed for opening later
    // sheets: using a closed sheet's context trips the
    // `_dependents.isEmpty`
    // assertion.
    builder: (_) => _ItemActionsSheet(item: item, host: context),
  );
}

class _ItemActionsSheet extends ConsumerWidget {
  const _ItemActionsSheet({required this.item, required this.host});

  final LocalItem item;

  /// The hosting screen's context, which stays alive after this sheet
  /// closes.
  final BuildContext host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final actions = ref.read(libraryActionsProvider);

    Future<void> run(
      Future<void> Function() action, {
      String? successText,
    }) async {
      Navigator.pop(context);
      try {
        await action();
        if (successText != null && host.mounted) {
          showVhSnack(host, successText, type: VhSnackType.success);
        }
      } catch (e) {
        if (host.mounted) {
          showErrorSnack(host, ref, e, tag: 'library');
        }
      }
    }

    ListTile tile(
      VhIconData icon,
      String label,
      VoidCallback onTap, {
      Color? color,
    }) => ListTile(
      leading: VhIcon(icon, color: color ?? p.ink2),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
      ),
      onTap: onTap,
    );

    // Scrolls when it outgrows the sheet: a sheet stops at nine sixteenths
    // of the screen, and on a short phone the last rows, delete among
    // them, were cut off.
    return SafeArea(
      child: SingleChildScrollView(
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
              child: VhForeignText(
                item.title,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            // **Favourites from the menu, not an empty heart on every card**:
            // the card shows a small heart on favourites alone, and the players
            // keep the one-tap heart.
            VhFavoriteTile(
              favorite: item.favorite,
              onTap: () async {
                Navigator.pop(context);
                final added = await actions.toggleFavorite(item.key);
                if (host.mounted) {
                  showVhSnack(
                    host,
                    added ? l10n.addedToFavorites : l10n.removedFromFavorites,
                  );
                }
              },
            ),
            tile(VhIcons.info, l10n.details, () {
              Navigator.pop(context);
              showItemDetailsSheet(host, item);
            }),
            tile(
              VhIcons.share,
              l10n.share,
              () => run(() => actions.share(host, [item])),
            ),
            // An external player gets a file path: everything here is
            // local, so no URL ever leaves the app.
            tile(
              VhIcons.playback,
              l10n.openInExternalPlayer,
              () => run(() async {
                final opened = await const ExternalPlayer().open(
                  item.path,
                  audio: item.isAudio,
                );
                if (!opened && host.mounted) {
                  showVhSnack(
                    host,
                    l10n.noExternalPlayer,
                    type: VhSnackType.error,
                  );
                }
              }),
            ),
            tile(VhIcons.queueAdd, l10n.addToPlaylist, () {
              Navigator.pop(context);
              showAddToPlaylistSheet(host, ref, [item]);
            }),
            // The original link is offered only where we know it; it is never
            // rebuilt from a guess.
            if (item.canonicalUrl != null)
              tile(VhIcons.external, l10n.openOriginalLink, () {
                Navigator.pop(context);
                openWebLink(item.canonicalUrl);
              }),
            const Divider(),
            tile(
              VhIcons.trash,
              l10n.deleteVideo,
              () => _confirm(
                context,
                l10n.deleteVideo,
                l10n.deleteVideoConfirm(vhName(item.title)),
                VhDialogClip(
                  title: vhName(item.title),
                  thumbnail: artworkFor(item.thumbnail, decodeWidth: 120),
                ),
                () {
                  run(
                    () => actions.deleteFiles([item]),
                    successText: l10n.deletedTitle(vhName(item.title)),
                  );
                },
              ),
              color: p.err,
            ),
            const SizedBox(height: VhSpace.md),
          ],
        ),
      ),
    );
  }

  /// **The clip itself is shown before anything is deleted** (the shared
  /// confirmation, as in the Windows app), so nobody removes the wrong one of
  /// two look-alike titles.
  Future<void> _confirm(
    BuildContext context,
    String title,
    String message,
    Widget clip,
    VoidCallback onYes,
  ) async {
    final l10n = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: title,
      message: message,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
      preview: clip,
    );
    if (sure) onYes();
  }
}

/// Bulk delete confirmation: deletes the files from the device.
void confirmBulkDelete(
  BuildContext context,
  WidgetRef ref,
  Set<String> selection,
) {
  final l10n = context.vhl;
  showVhDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      content: Text(l10n.deleteMultipleConfirm(selection.length)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            final all = ref.read(localMediaProvider).valueOrNull ?? const [];
            final targets = [
              for (final item in all)
                if (selection.contains(item.key)) item,
            ];
            try {
              final count = await ref
                  .read(libraryActionsProvider)
                  .deleteFiles(targets);
              ref.read(libraryViewProvider.notifier).clearSelection();
              if (context.mounted) {
                showVhSnack(
                  context,
                  l10n.deletedCount(count),
                  type: VhSnackType.success,
                );
              }
            } catch (e) {
              if (context.mounted) {
                showErrorSnack(context, ref, e, tag: 'library');
              }
            }
          },
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
}
