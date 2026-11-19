import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_item_row.dart';
import 'pc_link_state.dart';
import 'pc_outbox.dart';
import 'pc_outbox_section.dart';

/// **The computer's downloads as the phone's own show**, so they do not
/// crowd the page: one shows its card;
/// more, counted with the links waiting to be sent, fold into one line
/// that opens them in a sheet.
class PcDownloadsStrip extends ConsumerWidget {
  const PcDownloadsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = ref.watch(pcViewProvider.select((v) => v.live));
    final waiting = ref.watch(pcOutboxProvider).length;
    final count = live.length + waiting;
    if (count == 0) return const SizedBox.shrink();
    if (count == 1) {
      return live.isEmpty
          ? const PcOutboxSection()
          : PcTaskRow(task: live.single);
    }
    final l10n = context.vhl;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.lg,
        VhSpace.xs,
        VhSpace.lg,
        VhSpace.sm,
      ),
      child: VhActiveDownloadsBar(
        label: l10n.pcDownloadsCount(count),
        actionLabel: l10n.viewAll,
        progress: pcAverageProgress(live),
        onTap: () => showPcDownloadsSheet(context),
      ),
    );
  }
}

/// The share done of what is being measured, 0 to 1; null when none is.
double? pcAverageProgress(List<PcTask> live) {
  final measured = [
    for (final t in live)
      if (t.phase == 'downloading' || t.phase == 'postprocessing') t.progress,
  ];
  if (measured.isEmpty) return null;
  return measured.reduce((a, b) => a + b) / measured.length / 100;
}

void showPcDownloadsSheet(BuildContext context) {
  unawaited(
    showVhSheet<void>(
      context: context,
      isScrollControlled: true,
      // The drag handle stays below the status bar, as the phone's own.
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _PcDownloadsSheet(),
    ),
  );
}

/// What the computer downloads now, what waits there, and what waits on
/// this phone to be sent; it follows them while open, and closes once
/// none is left.
class _PcDownloadsSheet extends ConsumerWidget {
  const _PcDownloadsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final live = ref.watch(pcViewProvider.select((v) => v.live));
    final waiting = ref.watch(pcOutboxProvider);
    if (live.isEmpty && waiting.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).maybePop();
      });
    }
    final running = [
      for (final t in live)
        if (t.phase != 'queued') t,
    ];
    final queued = [
      for (final t in live)
        if (t.phase == 'queued') t,
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.only(bottom: VhSpace.xl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VhSpace.lg,
              0,
              VhSpace.lg,
              VhSpace.sm,
            ),
            child: Text(
              l10n.pcDownloadsSheet,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (running.isNotEmpty) ...[
            PcHeader(title: '${l10n.pcNow} · ${running.length}'),
            for (final task in running) PcTaskRow(task: task),
          ],
          if (queued.isNotEmpty) ...[
            PcHeader(title: '${l10n.queuedSection} · ${queued.length}'),
            for (final task in queued) PcTaskRow(task: task),
          ],
          const PcOutboxSection(),
        ],
      ),
    );
  }
}

/// A download on the computer, drawn as the phone's own downloads are:
/// its progress, and a way to stop it.
class PcTaskRow extends ConsumerWidget {
  const PcTaskRow({super.key, required this.task});

  final PcTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final phase = task.phase;
    final measured = phase == 'downloading' || phase == 'postprocessing';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.lg,
        vertical: VhSpace.xxs,
      ),
      child: VhDownloadProgressCard(
        // A new phase starts its own count, as on the phone's own cards.
        key: ValueKey('${task.id}-$phase'),
        title: task.title ?? task.url,
        statusText: switch (phase) {
          'queued' => l10n.queuedSection,
          'preparing' => l10n.enginePreparing,
          'postprocessing' => l10n.enginePostprocessing,
          'paused' => l10n.enginePaused,
          _ => l10n.downloadingTitle,
        },
        detail: phase == 'downloading' && task.speed != null
            ? vhFormatTransferRate(task.speed!)
            : null,
        progress: measured ? task.progress / 100 : null,
        waiting: phase == 'queued',
        thumbnail: PcThumb(url: task.thumbnail),
        onCancel: () =>
            unawaited(ref.read(pcViewProvider.notifier).cancel(task.id)),
      ),
    );
  }
}
