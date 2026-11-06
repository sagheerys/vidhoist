import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_media/library.dart';
import 'package:mt_media/mt_media.dart';

import '../di.dart';
import 'engine_data.dart';

/// The downloads made on this computer, in the shape the server's history
/// had: the library, the details and the statistics read it unchanged.
final historyProvider = FutureProvider<HistoryResponse?>((ref) async {
  final local = await ref.watch(localLibraryProvider.future);
  return HistoryResponse(done: [for (final entry in local) entry.item]);
});

/// Each local download's file, by its link: what makes it play from here.
final localFilesProvider = FutureProvider<Map<String, String>>((ref) async {
  final local = await ref.watch(localLibraryProvider.future);
  return {for (final entry in local) entry.item.canonicalUrl: entry.path};
});

final offlineIndexProvider = Provider(
  (ref) => OfflineIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

final tagsIndexProvider = Provider(
  (ref) => TagsIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    // Stamped like Super's, so a later merge with the phone knows which
    // write is newer.
    clock: DateTime.now,
  ),
);

final artworkIndexProvider = Provider(
  (ref) => ArtworkIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Online covers kept as files on this computer (see CoverKeeper).
final keptCoverIndexProvider = Provider(
  (ref) => KeptCoverIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

final mediaShapeIndexProvider = Provider(
  (ref) => MediaShapeIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// The unified library, merged exactly as on the phone.
final libraryItemsProvider = FutureProvider<List<LibraryItem>>((ref) async {
  final offline = {
    ...await ref.watch(offlineIndexProvider).readAll(),
    ...await ref.watch(localFilesProvider.future),
  };
  return mergeLibrary(
    history: await ref.watch(historyProvider.future),
    offline: offline,
    tags: await ref.watch(tagsIndexProvider).readAll(),
    artwork: await ref.watch(artworkIndexProvider).readAll(),
    shapes: await ref.watch(mediaShapeIndexProvider).readAll(),
    kept: await ref.watch(keptCoverIndexProvider).readAll(),
  );
});

/// The last session, back paused, as on the phone: opening the app never
/// starts sound by itself. Watched by the shell once.
final sessionRestoreProvider = FutureProvider<bool>(
  (ref) => ref.read(playerProvider).restoreSession(),
);
