import 'dart:async';

import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart' show VhTableColumn, VhTableSort;

import '../../data/library_data.dart';
import '../../di.dart';

/// The three ways the Windows library lays itself out: the tablet's three,
/// with the list as a table. The phone's one-column cards have no use on a
/// wide window.
const desktopLibraryModes = [
  LibraryViewMode.grid,
  LibraryViewMode.list,
  LibraryViewMode.compact,
];

/// The library's filters and layout. The sort order and the layout are
/// saved under the phone's keys, in this computer's own storage.
class DesktopLibraryNotifier extends Notifier<LibraryViewOptions> {
  static const sortKey = 'video_sort_option';
  static const modeKey = 'library_view_mode';

  @override
  LibraryViewOptions build() {
    unawaited(_load());
    return const LibraryViewOptions(mode: LibraryViewMode.grid);
  }

  Future<void> _load() async {
    final store = ref.read(keyValueStoreProvider);
    final sort = await store.getString(sortKey);
    final mode = await store.getString(modeKey);
    state = state.copyWith(
      sort: LibrarySort.values.asNameMap()[sort] ?? state.sort,
      mode: _ember(LibraryViewMode.values.asNameMap()[mode]) ?? state.mode,
    );
  }

  /// A layout saved by a build that had more of them reads as the grid.
  static LibraryViewMode? _ember(LibraryViewMode? mode) => mode == null
      ? null
      : desktopLibraryModes.contains(mode)
      ? mode
      : LibraryViewMode.grid;

  void setType(MediaTypeFilter type) => state = state.copyWith(type: type);

  /// The same platform again clears it, so a chip is a toggle.
  void togglePlatform(MediaPlatform platform) => state = state.copyWith(
    platform: () => state.platform == platform ? null : platform,
  );

  /// Neutral, included, excluded, neutral: one chip, three states, as on
  /// the phone.
  void cycleTag(String tag) {
    final included = Set<String>.from(state.tags);
    final excluded = Set<String>.from(state.excludedTags);
    if (included.remove(tag)) {
      excluded.add(tag);
    } else if (!excluded.remove(tag)) {
      included.add(tag);
    }
    state = state.copyWith(tags: included, excludedTags: excluded);
  }

  /// The library through one tag alone, as a tag on the lists page opens
  /// it.
  void showTag(String tag) => state = state.copyWith(
    type: MediaTypeFilter.all,
    platform: () => null,
    folder: () => null,
    tags: {tag},
    excludedTags: const {},
  );

  /// One folder and everything below it; null is every folder.
  void setFolder(String? folder) =>
      state = state.copyWith(folder: () => folder);

  /// "All": every filter off but the place itself.
  void clearFilters() => state = state.copyWith(
    type: MediaTypeFilter.all,
    platform: () => null,
    folder: () => null,
    tags: const {},
    excludedTags: const {},
  );

  Future<void> setSort(LibrarySort sort) =>
      _save(() => state = state.copyWith(sort: sort), sortKey, sort.name);

  Future<void> setMode(LibraryViewMode mode) =>
      _save(() => state = state.copyWith(mode: mode), modeKey, mode.name);

  Future<void> _save(void Function() apply, String key, String value) {
    apply();
    return ref
        .read(prefsMutexProvider)
        .run(() => ref.read(keyValueStoreProvider).setString(key, value));
  }
}

final libraryViewProvider =
    NotifierProvider<DesktopLibraryNotifier, LibraryViewOptions>(
      DesktopLibraryNotifier.new,
    );

/// The library as shown for a place: everything, favourites or offline.
/// **A value, once there, stays on screen** while a refresh runs.
final visibleLibraryProvider =
    Provider.family<AsyncValue<List<LibraryItem>>, LibraryScope>((ref, scope) {
      final options = ref.watch(libraryViewProvider);
      final all = ref.watch(libraryItemsProvider);
      final items = all.valueOrNull;
      if (items == null) {
        return all.hasError
            ? AsyncError(all.error!, all.stackTrace ?? StackTrace.empty)
            : const AsyncLoading();
      }
      return AsyncData(
        buildLibraryView(
          items,
          scope: scope,
          type: options.type,
          tags: options.tags,
          excludedTags: options.excludedTags,
          platform: options.platform,
          folder: options.folder,
          sort: options.sort,
        ),
      );
    });

/// Platform counters **over the place being looked at** (everything,
/// favourites, or what is kept offline), not over the other filters, so a
/// chip never shows zero for what the filter itself hid, and never offers
/// "Instagram 564" on an Offline page that holds nothing.
final platformCountsProvider =
    Provider.family<List<MapEntry<MediaPlatform, int>>, LibraryScope>(
      (ref, scope) => platformCounts(
        buildLibraryView(
          ref.watch(libraryItemsProvider).valueOrNull ?? [],
          scope: scope,
        ),
      ),
    );

/// The user's tags, most used first.
final libraryTagsProvider = Provider<List<String>>((ref) {
  final counts = <String, int>{};
  for (final item in ref.watch(libraryItemsProvider).valueOrNull ?? []) {
    for (final tag in item.tags) {
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
  }
  return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      .map((e) => e.key)
      .toList();
});

/// The table header's sorting, in terms of the saved sort order: each
/// column has its two directions, and a click on a new column starts with
/// the one people usually want (A to Z, largest, newest).
VhTableSort tableSortFor(LibrarySort sort, ValueChanged<LibrarySort> onSort) {
  final (column, ascending) = switch (sort) {
    LibrarySort.nameAZ => (VhTableColumn.title, true),
    LibrarySort.nameZA => (VhTableColumn.title, false),
    LibrarySort.smallest => (VhTableColumn.size, true),
    LibrarySort.largest => (VhTableColumn.size, false),
    LibrarySort.oldest => (VhTableColumn.added, true),
    LibrarySort.newest => (VhTableColumn.added, false),
  };
  return VhTableSort(
    column: column,
    ascending: ascending,
    onSort: (picked) => onSort(switch (picked) {
      VhTableColumn.title =>
        sort == LibrarySort.nameAZ ? LibrarySort.nameZA : LibrarySort.nameAZ,
      VhTableColumn.size =>
        sort == LibrarySort.largest
            ? LibrarySort.smallest
            : LibrarySort.largest,
      VhTableColumn.added =>
        sort == LibrarySort.newest ? LibrarySort.oldest : LibrarySort.newest,
    }),
  );
}
