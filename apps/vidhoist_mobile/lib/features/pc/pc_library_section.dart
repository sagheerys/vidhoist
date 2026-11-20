import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../player/caption_style.dart';
import 'pc_browse.dart';
import 'pc_item_row.dart';
import 'pc_outbox_section.dart';

/// The computer's library on the Computer page, as slivers: its heading
/// with the order button, the search, then the clips built only as they
/// scroll into sight, so a library of thousands costs what one screen
/// does.
List<Widget> pcLibrarySlivers(
  BuildContext context,
  WidgetRef ref, {
  required PcBrowse browse,
  required bool sorts,
}) {
  final l10n = context.vhl;
  final p = VhThemeX.of(context).palette;
  final text = Theme.of(context).textTheme;
  final notifier = ref.read(pcBrowseProvider.notifier);
  // Searched or sorted, the heading counts what was found; as it opens, the
  // whole library. Nothing found is said once, under it.
  final title = !browse.isDefault && browse.total > 0
      ? l10n.pcFoundCount(browse.total)
      : browse.total == 0
      ? l10n.pcLibrary
      : '${l10n.pcLibrary} · ${browse.total}';
  final searching = !browse.isDefault || browse.total > 0;

  Widget note(String message, {Color? color}) => Padding(
    padding: const EdgeInsets.all(VhSpace.xl),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: text.bodyMedium?.copyWith(color: color ?? p.ink2),
    ),
  );

  return [
    SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: PcHeader(title: title)),
              if (browse.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: VhSpace.sm),
                  child: VhSpinner(size: 16),
                ),
              // Only a computer that understands the order is offered one:
              // an older one answers newest first whatever is asked.
              if (sorts)
                IconButton(
                  tooltip: l10n.sortBy,
                  onPressed: () => unawaited(_showOrder(context, ref)),
                  icon: VhIcon(
                    VhIcons.sort,
                    color:
                        browse.sort == PcLibrarySort.newest &&
                            browse.kind == PcLibraryKind.all
                        ? p.ink2
                        : p.accent,
                  ),
                ),
              const SizedBox(width: VhSpace.xs),
            ],
          ),
          if (searching)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                VhSpace.lg,
                0,
                VhSpace.lg,
                VhSpace.sm,
              ),
              child: VhQuerySearchField(
                hint: l10n.pcSearchHint,
                query: browse.query,
                onChanged: notifier.search,
              ),
            ),
        ],
      ),
    ),
    if (browse.items.isEmpty)
      SliverToBoxAdapter(
        child: browse.failed
            ? note(l10n.pcErrUnreachable, color: p.err)
            : browse.loading
            ? const SizedBox(height: VhSpace.xxl)
            : note(browse.isDefault ? l10n.pcEmptyLibrary : l10n.noResults),
      )
    else ...[
      if (browse.failed)
        SliverToBoxAdapter(child: note(l10n.pcErrUnreachable, color: p.err)),
      // The page's margin, as the phone's own library keeps it: without
      // it the covers met the screen's edge.
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
        sliver: SliverList.builder(
          itemCount: browse.items.length,
          itemBuilder: (context, i) =>
              PcItemRow(item: browse.items[i], items: browse.items),
        ),
      ),
      if (browse.loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(VhSpace.lg),
            child: Center(child: VhSpinner(size: 20)),
          ),
        ),
    ],
  ];
}

/// Asks for the next page once the list is within a screen of its end.
bool pcLoadMoreNear(ScrollNotification event, WidgetRef ref) {
  if (event.metrics.axis == Axis.vertical &&
      event.metrics.extentAfter < event.metrics.viewportDimension) {
    unawaited(ref.read(pcBrowseProvider.notifier).loadMore());
  }
  return false;
}

/// The order and the kind, as the library's own sort sheet offers them.
Future<void> _showOrder(BuildContext context, WidgetRef ref) =>
    showVhSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final l10n = context.vhl;
          final text = Theme.of(context).textTheme;
          final browse = ref.watch(pcBrowseProvider);
          final notifier = ref.read(pcBrowseProvider.notifier);
          final sorts = {
            PcLibrarySort.newest: l10n.sortNewest,
            PcLibrarySort.oldest: l10n.sortOldest,
            PcLibrarySort.title: l10n.sortNameAZ,
            PcLibrarySort.size: l10n.sortLargest,
          };
          final kinds = {
            PcLibraryKind.all: l10n.filterAll,
            PcLibraryKind.video: l10n.filterVideo,
            PcLibraryKind.audio: l10n.filterAudio,
          };
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VhSpace.pagePad,
                0,
                VhSpace.pagePad,
                VhSpace.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.sortBy, style: text.titleMedium),
                  const SizedBox(height: VhSpace.sm),
                  CaptionChoiceChips(
                    labels: sorts.values.toList(),
                    chosen: sorts.keys.toList().indexOf(browse.sort),
                    onChosen: (i) =>
                        notifier.order(sort: sorts.keys.elementAt(i)),
                  ),
                  const SizedBox(height: VhSpace.lg),
                  CaptionChoiceChips(
                    labels: kinds.values.toList(),
                    chosen: kinds.keys.toList().indexOf(browse.kind),
                    onChosen: (i) =>
                        notifier.order(kind: kinds.keys.elementAt(i)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
