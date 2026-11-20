import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../library_providers.dart';
import '../local_item.dart';
import 'library_chips.dart';

/// The sort and platform sheet: the sort and view mode, saved, and the
/// platform filter, which used to be a second row above the list.
void showSortSheet(BuildContext context, WidgetRef ref) {
  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    // Sized to its options rather than capped at 9/16 of the screen, and
    // scrollable, so the platforms never hide the view modes.
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _SortSheet(),
  );
}

class _SortSheet extends ConsumerWidget {
  const _SortSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final options = ref.watch(libraryViewProvider);
    final controller = ref.read(libraryViewProvider.notifier);

    final sortLabels = {
      LibrarySort.newest: l10n.sortNewest,
      LibrarySort.oldest: l10n.sortOldest,
      LibrarySort.nameAZ: l10n.sortNameAZ,
      LibrarySort.nameZA: l10n.sortNameZA,
      LibrarySort.largest: l10n.sortLargest,
      LibrarySort.smallest: l10n.sortSmallest,
    };

    return SingleChildScrollView(
      child: Padding(
        // The last option used to fall under the three navigation buttons;
        // a sheet always reaches the screen edge.
        padding: EdgeInsets.fromLTRB(
          VhSpace.xl,
          VhSpace.lg,
          VhSpace.xl,
          vhSheetBottomPad(context, VhSpace.xxl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.sortAndPlatform,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: VhSpace.lg),
            VhSectionHeader(title: l10n.sortBy),
            const SizedBox(height: VhSpace.md),
            Wrap(
              spacing: VhSpace.xs,
              runSpacing: VhSpace.xs,
              children: [
                for (final MapEntry(:key, :value) in sortLabels.entries)
                  ChoiceChip(
                    label: Text(value),
                    selected: options.sort == key,
                    showCheckmark: false,
                    labelStyle: Theme.of(context).textTheme.labelMedium!
                        .copyWith(
                          color: options.sort == key
                              ? VhThemeX.of(context).palette.bg
                              : VhThemeX.of(context).palette.ink2,
                        ),
                    onSelected: (_) => controller.setSort(key),
                  ),
              ],
            ),
            const SizedBox(height: VhSpace.xl),
            // **Four modes instead of overlapping flags**: compact and grid
            // were two
            // switches that could be on together meaninglessly, and a fourth
            // would
            // have doubled the impossible states. One choice prevents them at
            // the
            // root.
            VhSectionHeader(title: l10n.viewMode),
            const SizedBox(height: VhSpace.md),
            Wrap(
              spacing: VhSpace.xs,
              runSpacing: VhSpace.xs,
              children: [
                for (final (label, mode) in <(String, LibraryViewMode)>[
                  (l10n.viewList, LibraryViewMode.list),
                  (l10n.compactView, LibraryViewMode.compact),
                  (l10n.viewGrid, LibraryViewMode.grid),
                  (l10n.viewCards, LibraryViewMode.cards),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: options.mode == mode,
                    showCheckmark: false,
                    labelStyle: Theme.of(context).textTheme.labelMedium!
                        .copyWith(
                          color: options.mode == mode
                              ? VhThemeX.of(context).palette.bg
                              : VhThemeX.of(context).palette.ink2,
                        ),
                    onSelected: (_) => controller.setMode(mode),
                  ),
              ],
            ),
            // Last, as its length depends on the library.
            const PlatformFilterChips(),
          ],
        ),
      ),
    );
  }
}
