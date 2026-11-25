import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/library.dart';

import '../../di.dart';
import '../../router.dart';
import 'palette_model.dart';

/// What one row of the palette does: [run], after the palette closes
/// unless it [stays] (a saved search fills the field instead); a row that
/// opens a [page] hands it the focus once the palette is gone.
typedef PaletteAct = ({VoidCallback run, bool page, bool stays});

/// Every row Enter can open, in the order they are drawn: the searches
/// kept, the titles (or the clips played last), the moments said, the
/// commands, then saving the search.
List<PaletteAct> paletteActs(
  PaletteResults r, {
  required WidgetRef ref,
  required GoRouter router,
  required ValueChanged<String> ask,
  required VoidCallback save,
}) => [
  for (final search in r.saved)
    (run: () => ask(search.query), page: false, stays: true),
  for (final item in r.titles)
    (
      run: () => router.go(DesktopRoutes.item(item.canonicalUrl)),
      page: true,
      stays: false,
    ),
  for (final match in r.said)
    (
      run: () =>
          unawaited(playFromMoment(ref, router, match.item, match.hit.start)),
      page: true,
      stays: false,
    ),
  for (final command in r.commands)
    (run: command.run, page: false, stays: false),
  if (r.canSave) (run: save, page: false, stays: false),
];

/// Plays [item] from [start], the moment the words were said, and opens
/// its page when it has a picture.
Future<void> playFromMoment(
  WidgetRef ref,
  GoRouter router,
  LibraryItem item,
  Duration start,
) async {
  final player = ref.read(playerProvider);
  await player.setLooping(false);
  await player.playItems([toPlaylistItem(item)]);
  await player.seek(start);
  if (!item.isAudio) router.go(DesktopRoutes.item(item.canonicalUrl));
}
