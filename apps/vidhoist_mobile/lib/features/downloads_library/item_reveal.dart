import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'library_providers.dart';
import 'local_item.dart';

/// A request to bring one library item before the user's eyes: a tap on a
/// "download complete" notification.
///
/// **Not the same as the highlight.** A download that completes while the
/// user is elsewhere only lights its item for when they come back; a tap
/// on its notification is the user asking to see it, so the app goes there.
/// Each tap is a new request, even for the same item twice.
class ItemReveal {
  ItemReveal(this.key);

  /// The item's library key: its canonical address, or its path.
  final String key;
}

final itemRevealProvider = StateProvider<ItemReveal?>((ref) => null);

/// Everything opened above the tabs closes, and the library tab shows.
///
/// Sheets and dialogs go first, since they are not pages the router knows;
/// then `go` takes the players off and selects the library, while the
/// other tabs keep where they were. Music goes on playing under the mini
/// player; a video keeps its position, saved as it closes.
void openLibraryForReveal(GoRouter router) {
  router.routerDelegate.navigatorKey.currentState?.popUntil(
    (route) => route.settings is Page,
  );
  router.go('/');
}

/// Makes [key] part of the list on screen, undoing only what hides it:
/// the selection always, the search if the item does not match it, and
/// the filters if they leave it out. False when the item is not in the
/// library at all.
bool showInLibrary(
  LibraryViewNotifier view,
  LibraryViewOptions options,
  List<LocalItem> all,
  String key,
) {
  if (!all.any((item) => item.key == key)) return false;
  if (options.selecting) view.clearSelection();
  bool visible(LibraryViewOptions o) => buildLocalLibraryView(
    all,
    scope: o.scope,
    type: o.type,
    query: o.query,
    platform: o.platform,
    sort: o.sort,
  ).any((item) => item.key == key);
  var shown = options;
  if (!visible(shown) && shown.query.isNotEmpty) {
    view.setQuery('');
    shown = shown.copyWith(query: '');
  }
  if (!visible(shown)) {
    view
      ..setScope(LocalScope.all)
      ..setType(MediaTypeFilter.all)
      ..setPlatform(null);
  }
  return true;
}

/// Scrolls until [target], the item at [index] of [count], is in view.
///
/// **The list builds only what is near the screen**, so an item far down
/// has no widget to scroll to yet. Its place is estimated from its share
/// of the list, which the list's own estimate of its length makes good
/// enough to build it; then the last stretch is an animated scroll to the
/// item itself.
Future<void> scrollToItem(
  ScrollController controller,
  GlobalKey target, {
  required int index,
  required int count,
}) async {
  for (var attempt = 0; attempt < 6; attempt++) {
    final built = target.currentContext;
    if (built != null && built.mounted) {
      await Scrollable.ensureVisible(
        built,
        alignment: 0.25,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    if (!controller.hasClients || count <= 0) return;
    final position = controller.position;
    final share = count == 1 ? 0.0 : index / (count - 1);
    position.jumpTo(
      (share * position.maxScrollExtent).clamp(0.0, position.maxScrollExtent),
    );
    await WidgetsBinding.instance.endOfFrame;
  }
}
