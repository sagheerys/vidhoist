import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import 'pc_link_state.dart';
import 'pc_stream.dart';

/// **The computer's saved lists, read there and played from there.** They
/// are not the phone's lists: those are files here that play with no link,
/// go into a backup and can be changed; these are gone while the computer
/// is, and change on the computer only. Asked for while a page shows them.
final pcListsProvider = FutureProvider.autoDispose<List<PcList>>((ref) async {
  final client = ref.watch(pcClientProvider);
  if (client == null) return const [];
  return client.lists();
});

/// One list with its clips that are files on the computer, in its order.
final pcListProvider = FutureProvider.autoDispose.family<PcList?, String>((
  ref,
  id,
) async {
  final client = ref.watch(pcClientProvider);
  if (client == null) return null;
  return client.list(id);
});

/// After a clip was deleted there, every list is read again.
void forgetPcLists(WidgetRef ref) {
  ref.invalidate(pcListsProvider);
  ref.invalidate(pcListProvider);
}

/// Plays a computer list from its first clip, or shuffled, as a list of the
/// phone's own plays: sound in the background when all of it is sound.
Future<void> playPcList(
  BuildContext context,
  WidgetRef ref,
  List<PcItem> items, {
  bool shuffle = false,
}) async {
  if (items.isEmpty) return;
  if (shuffle) await ref.read(playbackPrefsProvider).setShuffle(true);
  if (!context.mounted) return;
  // A list with a video in it opens the player, as the phone's lists do;
  // one of sound alone stays in the background.
  await playFromPc(
    context,
    ref,
    items,
    items.first,
    video: items.any((i) => !i.isAudio),
  );
}
