import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_link_state.dart';
import 'pc_outbox.dart';
import 'pc_stream.dart';

/// While links wait for the computer, asks it once a minute; its first
/// answer sends them. Lives with the shell, so a link waits through a
/// restart and goes without the page being opened.
final pcOutboxRetryProvider = Provider<void>((ref) {
  Timer? timer;
  void follow(List<PcQueued> queued) {
    if (!queued.any((q) => !q.refused)) {
      timer?.cancel();
      timer = null;
      return;
    }
    if (timer != null) return;
    void ask() => unawaited(ref.read(pcViewProvider.notifier).probe());
    timer = Timer.periodic(const Duration(minutes: 1), (_) => ask());
    ask();
  }

  ref.listen(
    pcOutboxProvider,
    (_, next) => follow(next),
    fireImmediately: true,
  );
  ref.onDispose(() => timer?.cancel());
});

/// **The count on the computer's tab**: downloads running there as last
/// seen, none once it stops answering, so a stale number never stays.
final pcRunningProvider = Provider<int>((ref) {
  final view = ref.watch(pcViewProvider);
  return view.failure == null ? view.live.length : 0;
});

/// Each download the computer finished while followed.
final pcDoneProvider = StreamProvider<PcTask>(
  (ref) => ref.watch(pcViewProvider.notifier).done,
);

/// **A word in the app when the computer finishes one**, with Play when
/// the clip is in its library. Not a phone notification: the phone learns
/// it only by asking, which it does only while the app is in front.
void listenPcDone(WidgetRef ref, BuildContext context) {
  ref.listen(pcDoneProvider, (_, next) {
    final task = next.valueOrNull;
    if (task == null || !context.mounted) return;
    final items = ref.read(pcViewProvider).items;
    final item =
        items.where((i) => i.url == task.url).firstOrNull ??
        items
            .where((i) => task.title != null && i.title == task.title)
            .firstOrNull;
    final l10n = context.vhl;
    showVhSnack(
      context,
      l10n.pcDoneOnPc(task.title ?? item?.title ?? task.url),
      type: VhSnackType.success,
      actionLabel: item == null ? null : l10n.play,
      onAction: item == null
          ? null
          : () => unawaited(playFromPc(context, ref, items, item)),
    );
  });
}
