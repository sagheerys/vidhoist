import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/lists_data.dart';
import '../../di.dart';
import '../../router.dart';
import '../../shell/pill.dart';
import 'list_actions.dart';
import 'list_dialogs.dart';
import 'playlist_line.dart';

/// One saved list: its actions, then its clips in its order, which a drag
/// by the grip changes. A click plays the list from that clip.
class PlaylistPage extends ConsumerWidget {
  const PlaylistPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final asked = ref.watch(playlistViewProvider(id));
    final view = asked.valueOrNull;
    Widget centered(Widget child) => Center(
      child: Padding(padding: const EdgeInsets.all(VhSpace.xl), child: child),
    );
    if (view == null) {
      return centered(
        asked.hasError
            ? VhEmptyFrame(
                title: l.emptyPlaylist,
                message: l.errorGeneric(asked.error.toString()),
                actionLabel: l.tryAgain,
                onAction: () => ref.invalidate(playlistsProvider),
              )
            : const VhSpinner(),
      );
    }
    if (view.playlist == null) {
      return centered(
        VhEmptyFrame(
          title: l.playlistDetails,
          message: l.noPlaylistsMessage,
          actionLabel: l.navPlaylists,
          onAction: () => context.go(DesktopRoutes.playlists),
        ),
      );
    }
    final player = ref.watch(playerProvider);
    return LayoutBuilder(
      builder: (context, box) {
        // The readable width, centred, as every list of rows on a wide
        // window.
        final side = math.max(
          VhSpace.xl,
          (box.maxWidth - VhBreakpoint.readable) / 2,
        );
        return StreamBuilder<VhPlayerState>(
          stream: player.states,
          initialData: player.state,
          builder: (context, snap) =>
              _Lines(view: view, side: side, state: snap.data ?? player.state),
        );
      },
    );
  }
}

class _Lines extends ConsumerWidget {
  const _Lines({required this.view, required this.side, required this.state});

  final PlaylistView view;
  final double side;
  final VhPlayerState state;

  void _remove(BuildContext context, WidgetRef ref, PlaylistItem item, int i) {
    final l = context.vhl;
    final actions = ref.read(listActionsProvider);
    final id = view.playlist!.id;
    unawaited(actions.remove(id, item));
    showVhNotice(
      context,
      message: l.removedFromPlaylist,
      actionLabel: l.undo,
      onAction: () => unawaited(actions.undoRemove(id, item, i)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final router = GoRouter.of(context);
    final actions = ref.read(listActionsProvider);
    final current = state.current?.canonicalUrl;
    final items = view.items;
    return ReorderableListView.builder(
      // The grip is drawn, not Material's icon, and only it starts a drag,
      // so a click on the line still plays.
      buildDefaultDragHandles: false,
      padding: EdgeInsets.fromLTRB(side, VhSpace.sm, side, VhSpace.xl),
      header: _Header(view: view),
      itemCount: items.length,
      onReorderItem: (from, to) =>
          unawaited(actions.reorder(view.playlist!.id, from, to)),
      itemBuilder: (context, i) {
        final item = items[i];
        final missing = view.isMissing(item);
        return PlaylistLine(
          key: ValueKey(item.canonicalUrl),
          index: i,
          item: item,
          missing: missing,
          current: !missing && item.canonicalUrl == current,
          playing: state.playing,
          onTap: () {
            if (missing) {
              showVhNotice(
                context,
                message: l.itemUnavailable,
                kind: VhNoticeKind.failed,
              );
              return;
            }
            // The place among what can play, not among the lines shown.
            final start = view.playable.indexWhere(
              (p) => p.canonicalUrl == item.canonicalUrl,
            );
            unawaited(actions.play(router, view, start: start));
          },
          onRemove: () => _remove(context, ref, item, i),
        );
      },
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.view});

  final PlaylistView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final actions = ref.read(listActionsProvider);
    final list = view.playlist!;
    final playable = view.playable.isNotEmpty;

    Future<void> rename() async {
      final name = await promptPlaylistName(context, initial: list.name);
      if (name != null) await actions.rename(list.id, name);
    }

    Future<void> delete() async {
      if (!await confirmDeletePlaylist(context, list.name)) return;
      await actions.delete(list.id);
      if (!context.mounted) return;
      showVhNotice(context, message: l.playlistDeleted);
      router.go(DesktopRoutes.playlists);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            list.name,
            textDirection: vhTextDirectionOf(
              list.name,
              Directionality.of(context),
            ),
            style: text.headlineSmall,
          ),
          const SizedBox(height: VhSpace.xxs),
          Text(
            vhMetaLine([
              l.queueItemsCount(list.items.length),
              if (list.pinned) l.desktopPinned,
            ]),
            style: text.bodySmall?.copyWith(color: p.ink3),
          ),
          const SizedBox(height: VhSpace.md),
          Wrap(
            spacing: VhSpace.sm,
            runSpacing: VhSpace.sm,
            children: [
              if (playable) ...[
                DesktopPill(
                  label: l.playAll,
                  icon: VhIcons.playFill,
                  selected: false,
                  onTap: () => unawaited(actions.play(router, view)),
                ),
                DesktopPill(
                  label: l.shuffle,
                  icon: VhIcons.shuffle,
                  selected: false,
                  onTap: () =>
                      unawaited(actions.play(router, view, shuffle: true)),
                ),
                DesktopPill(
                  // The phone's headphones; a computer has no background
                  // to send it to, so it says what it does.
                  label: l.audioOnly,
                  icon: VhIcons.headphones,
                  selected: false,
                  onTap: () =>
                      unawaited(actions.play(router, view, audioOnly: true)),
                ),
              ],
              DesktopPill(
                label: list.pinned ? l.unpinPlaylist : l.pinPlaylist,
                selected: list.pinned,
                onTap: () =>
                    unawaited(actions.setPinned(list.id, !list.pinned)),
              ),
              DesktopPill(
                label: l.rename,
                selected: false,
                onTap: () => unawaited(rename()),
              ),
              if (view.missing.isNotEmpty)
                DesktopPill(
                  label: l.removeUnavailable(view.missing.length),
                  selected: false,
                  onTap: () =>
                      unawaited(actions.removeMissing(list.id, view.missing)),
                ),
              DesktopPill(
                label: l.delete,
                icon: VhIcons.trash,
                selected: false,
                onTap: () => unawaited(delete()),
              ),
            ],
          ),
          if (list.items.isEmpty) ...[
            const SizedBox(height: VhSpace.xxl),
            Center(
              child: VhEmptyFrame(
                title: l.emptyPlaylist,
                message: l.emptyPlaylistMessage,
                actionLabel: l.navLibrary,
                onAction: () => router.go(DesktopRoutes.library),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
