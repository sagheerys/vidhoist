import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart' show DownloadTask;
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/engine_data.dart';
import '../../data/library_data.dart';
import '../../di.dart';
import '../../router.dart';
import '../add/add_dialog.dart';
import '../add/add_entry.dart';
import '../clip/clip_state.dart';
import 'first_link.dart';
import '../star/star_ask_corner.dart';
import 'library_chips.dart';
import 'library_heading.dart';
import 'library_skeleton.dart';
import 'library_item_view.dart';
import 'library_scroll.dart';
import 'library_state.dart';
import 'pending_clip.dart';
import 'selection.dart';
import 'selection_bar.dart';

/// No filter narrows the list: only then do clips on their way stand in
/// it, since nothing is known yet of their kind, site or tags.
bool _unfiltered(LibraryViewOptions o) =>
    o.type == MediaTypeFilter.all &&
    o.platform == null &&
    o.channel == null &&
    o.folder == null &&
    o.tags.isEmpty &&
    o.excludedTags.isEmpty;

/// The library: the whole unified library, or the favourites, with the
/// filters in view and three layouts.
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key, this.scope = LibraryScope.all});

  final LibraryScope scope;

  /// The place a route's `only=` names.
  static LibraryScope scopeOf(String? only) => switch (only) {
    'favorites' => LibraryScope.favorites,
    _ => LibraryScope.all,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final options = ref.watch(libraryViewProvider);
    final visible = ref.watch(visibleLibraryProvider(scope));
    final all = ref.watch(libraryItemsProvider).valueOrNull ?? const [];
    final title = switch (scope) {
      LibraryScope.favorites => l.favorites,
      _ => l.navLibrary,
    };
    // What this place holds before any chip: its own count, and the
    // message when it holds nothing yet.
    final held = switch (scope) {
      LibraryScope.favorites => all.where((i) => i.favorite).length,
      _ => all.length,
    };
    final pending = scope == LibraryScope.all && _unfiltered(options)
        ? ref.watch(pendingClipsProvider)
        : const <DownloadTask>[];
    final counts = vhMetaLine([
      if (all.isNotEmpty) l.transcriptsClips(held),
      if (pending.isNotEmpty) l.desktopLibraryDownloading(pending.length),
    ]);

    return StarAskCorner(
      child: SelectionFrame(
        items: visible.valueOrNull ?? const [],
        child: LibraryScroll(
          place: libraryPlaceKey(scope, options),
          builder: (controller) => CustomScrollView(
            controller: controller,
            slivers: [
              PinnedHeaderSliver(
                child: PinnedLibraryHeading(
                  child: LibraryHeading(
                    title: title,
                    counts: counts.isEmpty ? null : counts,
                    tools: all.isNotEmpty,
                    layouts: all.isNotEmpty || pending.isNotEmpty,
                    mode: options.mode,
                    onMode: (m) => unawaited(
                      ref.read(libraryViewProvider.notifier).setMode(m),
                    ),
                    sort: options.sort,
                    onSort: (s) => unawaited(
                      ref.read(libraryViewProvider.notifier).setSort(s),
                    ),
                  ),
                ),
              ),
              // Filters for a library that holds nothing yet would filter
              // nothing.
              if (all.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    VhSpace.xl,
                    VhSpace.xs,
                    VhSpace.xl,
                    VhSpace.md,
                  ),
                  sliver: SliverList.list(
                    children: [LibraryChips(scope: scope)],
                  ),
                ),
              ..._content(context, ref, visible, all, held, pending),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<LibraryItem>> visible,
    List<LibraryItem> all,
    int held,
    List<DownloadTask> pending,
  ) {
    final l = context.vhl;
    // A plain box that scrolls with the page, not a fill: a filling sliver
    // measured the message too short under a large font and squeezed it.
    Widget fill(Widget child) => SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: VhSpace.xxl * 2),
        child: Center(child: child),
      ),
    );
    final items = visible.valueOrNull;
    if (items == null) {
      if (visible.hasError) {
        return [
          fill(
            VhEmptyFrame(
              title: l.failed,
              message: l.errorGeneric('${visible.error}'),
              actionLabel: l.retry,
              onAction: () => ref.invalidate(localLibraryProvider),
            ),
          ),
        ];
      }
      return [fill(const LibrarySkeleton())];
    }
    if (items.isEmpty && pending.isEmpty) {
      return [
        fill(
          all.isEmpty
              ? FirstLink(
                  // What the clipboard holds, as the sidebar's button does.
                  onAdd: () async {
                    final text = await clipboardLinks();
                    if (context.mounted) {
                      unawaited(openAddDialog(context, text: text));
                    }
                  },
                )
              // Nothing here yet is not a filter that hides too much.
              : held == 0 && scope == LibraryScope.favorites
              ? VhEmptyFrame(
                  title: l.desktopNoFavoritesTitle,
                  message: l.desktopNoFavoritesMessage,
                  actionLabel: l.navLibrary,
                  onAction: () =>
                      GoRouter.of(context).go(DesktopRoutes.library),
                )
              : VhEmptyFrame(
                  title: l.desktopNoMatchTitle,
                  message: l.desktopNoMatchMessage,
                  actionLabel: l.desktopClearFilters,
                  onAction: ref.read(libraryViewProvider.notifier).clearFilters,
                ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          VhSpace.xl,
          0,
          VhSpace.xl,
          VhSpace.xl,
        ),
        sliver: _Items(items: items, pending: pending),
      ),
    ];
  }
}

/// The items, in the chosen layout, marking the one in the player; the
/// clips on their way lead, since they are the newest.
class _Items extends ConsumerWidget {
  const _Items({required this.items, required this.pending});

  final List<LibraryItem> items;
  final List<DownloadTask> pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(libraryViewProvider);
    final view = ref.read(libraryViewProvider.notifier);
    final player = ref.watch(playerProvider);
    final chosen = ref.watch(librarySelectionProvider).urls;
    final order = [for (final i in items) i.canonicalUrl];
    // A new layout, order or filter fades the list in; typing a search
    // does not, or every key would flash it.
    return SliverFadeOnChange(
      value: (
        options.mode,
        options.sort,
        options.type,
        options.platform,
        options.channel,
        options.folder,
        options.tags.join(' '),
        options.excludedTags.join(' '),
      ),
      sliver: StreamBuilder<VhPlayerState>(
        stream: player.states,
        initialData: player.state,
        builder: (context, snap) {
          final state = snap.data ?? player.state;
          final current = state.current?.canonicalUrl;
          return VhLibrarySliver(
            pinHeader: true,
            layout: switch (options.mode) {
              LibraryViewMode.list => VhLibraryLayout.list,
              LibraryViewMode.compact => VhLibraryLayout.compact,
              _ => VhLibraryLayout.grid,
            },
            showLocation: true,
            sort: tableSortFor(options.sort, (s) => unawaited(view.setSort(s))),
            itemCount: pending.length + items.length,
            itemBuilder: (context, at, columns) {
              if (at < pending.length) {
                return PendingClipView(
                  key: ValueKey(pending[at].id),
                  task: pending[at],
                  mode: options.mode,
                  columns: columns,
                );
              }
              final index = at - pending.length;
              final item = items[index];
              final isCurrent = item.canonicalUrl == current;
              return LibraryItemView(
                item: item,
                mode: options.mode,
                columns: columns,
                playing: isCurrent,
                paused: isCurrent && !state.playing,
                selected: chosen.contains(item.canonicalUrl),
                choosing: chosen.isNotEmpty,
                onChoose: () => ref
                    .read(librarySelectionProvider.notifier)
                    .click(item.canonicalUrl, order),
                onToggle: () => ref
                    .read(librarySelectionProvider.notifier)
                    .toggle(item.canonicalUrl),
                // The list on screen becomes the queue, from the clip
                // clicked, as on the phone; a video opens its page and a
                // short its lane.
                onPlay: () => unawaited(
                  openFromList(ref, GoRouter.of(context), [
                    for (final i in items) toPlaylistItem(i),
                  ], index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
