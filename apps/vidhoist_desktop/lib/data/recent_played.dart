import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';

import '../di.dart';
import 'library_data.dart';

/// How many clips the palette offers before a word is typed.
const recentlyPlayedShown = 5;

/// **The library's clips by when they last played here**, the latest
/// first: the player stamps each position it saves, and a clip played to
/// its end too. A clip never played is not among them.
///
/// Read afresh each time the palette opens and let go when it closes, so
/// it always reflects the latest playback.
final recentlyPlayedProvider = FutureProvider.autoDispose<List<LibraryItem>>((
  ref,
) async {
  final items = await ref.watch(libraryItemsProvider.future);
  final positions = PlaybackPositionStore(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  );
  final stamped = <(DateTime, LibraryItem)>[];
  for (final item in items) {
    final at = await positions.stampOf(item.canonicalUrl);
    if (at != null) stamped.add((at, item));
  }
  stamped.sort((a, b) => b.$1.compareTo(a.$1));
  return [for (final (_, item) in stamped.take(recentlyPlayedShown)) item];
});
