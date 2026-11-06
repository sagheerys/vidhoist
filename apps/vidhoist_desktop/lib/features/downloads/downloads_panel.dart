import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../data/downloads_data.dart';
import '../../data/folders_data.dart';
import '../../data/local_copies.dart';
import '../../shell/section_header.dart';
import '../add/links_view.dart';
import 'panel_line.dart';

/// The downloads, opened from the button above the content and drawn at
/// its corner: what is being fetched, what is paused, what waits its turn,
/// what is coming from a server, and what failed, each with its own action.
Future<void> showDownloadsPanel(BuildContext context) => showGeneralDialog(
  context: context,
  barrierDismissible: true,
  barrierLabel: context.mtl.desktopDownloads,
  barrierColor: Colors.transparent,
  transitionDuration: mtMotionDuration(context, MTMotion.page),
  // It grows from the button's corner as it fades in, as a menu does.
  transitionBuilder: (context, animation, _, child) {
    final eased = CurvedAnimation(
      parent: animation,
      curve: MTMotion.entrance,
      reverseCurve: MTMotion.exit,
    );
    return FadeTransition(
      opacity: eased,
      child: ScaleTransition(
        alignment: AlignmentDirectional.topEnd.resolve(
          Directionality.of(context),
        ),
        scale: Tween<double>(begin: 0.97, end: 1).animate(eased),
        child: child,
      ),
    );
  },
  pageBuilder: (context, _, _) => const DownloadsPanel(),
);

class DownloadsPanel extends ConsumerWidget {
  const DownloadsPanel({super.key});

  static const double width = 420;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.mtl;
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final engine = ref.watch(downloadEngineProvider);
    final tasks = ref.watch(engineTasksProvider).valueOrNull ?? const [];
    final copies = ref.watch(localCopiesProvider);
    final working = [
      for (final t in tasks)
        if (isUnderWay(t) && t.phase != TaskPhase.queued) t,
    ];
    final paused = [
      for (final t in tasks)
        if (t.phase == TaskPhase.paused) t,
    ];
    final waiting = [
      for (final t in tasks)
        if (t.phase == TaskPhase.queued) t,
    ];
    final failed = [
      for (final t in tasks)
        if (t.phase == TaskPhase.failed) t,
    ];
    // Only lines the panel shows: a clip the server finished has no line
    // here, so it never offers to hide what cannot be seen.
    final finished = copies.any((c) => !c.isActive);
    final empty =
        working.isEmpty &&
        paused.isEmpty &&
        waiting.isEmpty &&
        failed.isEmpty &&
        copies.isEmpty;

    // Hides finished lines from this panel; nothing is deleted, here or on
    // the server.
    void clearFinished() {
      ref.read(localCopiesProvider.notifier).clearFinished();
      for (final t in tasks) {
        if (t.isFinished && t.phase != TaskPhase.failed) engine?.forget(t.id);
      }
    }

    return SafeArea(
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: MTSpace.xxl + MTSpace.xl,
            end: MTSpace.xl,
            bottom: MTSpace.xl,
            start: MTSpace.xl,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: width),
            child: Material(
              color: p.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MTCorners.desktop.card),
                side: BorderSide(
                  color: p.line2,
                  width: MTThemeX.of(context).hairline,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(MTSpace.md),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.desktopDownloads,
                          style: text.titleMedium,
                        ),
                      ),
                      if (finished)
                        MTLinkButton(
                          label: l.desktopClearFinished,
                          onPressed: clearFinished,
                        ),
                    ],
                  ),
                  if (empty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: MTSpace.lg),
                      child: Text(
                        l.desktopDownloadsEmpty,
                        style: text.bodyMedium?.copyWith(color: p.ink2),
                      ),
                    ),
                  if (working.isNotEmpty) ...[
                    EmberSectionHeader(title: l.desktopDownloadsRunning),
                    for (final t in working)
                      _TaskLine(
                        task: t,
                        onCancel: () => engine?.cancel(t.id),
                        // Merging or converting is quick and cannot be
                        // continued later: only a download pauses.
                        onPause: t.phase == TaskPhase.postprocessing
                            ? null
                            : () => engine?.pause(t.id),
                      ),
                  ],
                  if (paused.isNotEmpty) ...[
                    EmberSectionHeader(title: l.enginePaused),
                    for (final t in paused)
                      _TaskLine(
                        task: t,
                        onCancel: () => engine?.cancel(t.id),
                        onResume: () => engine?.resume(t.id),
                      ),
                  ],
                  if (waiting.isNotEmpty) ...[
                    EmberSectionHeader(title: l.queuedSection),
                    for (final t in waiting)
                      _TaskLine(task: t, onCancel: () => engine?.cancel(t.id)),
                  ],
                  if (copies.isNotEmpty) ...[
                    EmberSectionHeader(title: l.desktopToThisComputer),
                    for (final c in copies) _CopyLine(copy: c),
                  ],
                  if (failed.isNotEmpty) ...[
                    EmberSectionHeader(title: l.needsAttention),
                    for (final t in failed)
                      _TaskLine(
                        task: t,
                        onCancel: () => engine?.forget(t.id),
                        onRetry: engine == null
                            ? null
                            : () {
                                engine.submit(
                                  t.effectiveUrl,
                                  t.quality,
                                  folder: t.folder,
                                );
                                engine.forget(t.id);
                              },
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A clip being fetched, paused, waiting its turn, or failed.
class _TaskLine extends StatelessWidget {
  const _TaskLine({
    required this.task,
    required this.onCancel,
    this.onRetry,
    this.onPause,
    this.onResume,
  });

  final DownloadTask task;
  final VoidCallback onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context) {
    final failed = task.phase == TaskPhase.failed;
    return PanelLine(
      title: task.title ?? task.effectiveUrl,
      thumbnail: task.thumbnail,
      status: taskLine(context.mtl, task),
      error: failed,
      // Waiting is not working: only a clip being fetched moves, and a
      // paused one keeps its bar where it stopped.
      progress: switch (task.phase) {
        TaskPhase.downloading || TaskPhase.paused => task.progress,
        TaskPhase.polling when task.hasKnownProgress => task.progress,
        TaskPhase.queued || TaskPhase.failed => null,
        _ => -1,
      },
      actions: [
        if (onRetry case final retry?)
          MTLinkButton(label: context.mtl.retry, onPressed: retry),
        if (onPause case final pause?)
          MTLinkButton(label: context.mtl.pause, onPressed: pause),
        if (onResume case final resume?)
          MTLinkButton(label: context.mtl.engineResume, onPressed: resume),
      ],
      onClose: onCancel,
    );
  }
}

/// A copy coming to this computer, or come.
class _CopyLine extends ConsumerWidget {
  const _CopyLine({required this.copy});

  final LocalCopy copy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.mtl;
    final copies = ref.read(localCopiesProvider.notifier);
    final percent = (copy.progress * 100).round();
    final status = switch (copy.phase) {
      CopyPhase.queued => l.desktopCopyQueued,
      CopyPhase.pulling when copy.kind == CopyKind.offline =>
        l.desktopSavingOffline(percent),
      CopyPhase.pulling => l.desktopDownloading(percent),
      CopyPhase.done when copy.kind == CopyKind.offline => l.madeOffline,
      CopyPhase.done => l.desktopSavedIn(copy.folder),
      CopyPhase.failed => l.failed,
      CopyPhase.cancelled => l.desktopCopyCancelled,
    };
    return PanelLine(
      title: copy.title,
      thumbnail: copy.thumbnail,
      status: status,
      error: copy.phase == CopyPhase.failed,
      done: copy.phase == CopyPhase.done,
      progress: switch (copy.phase) {
        CopyPhase.pulling => copy.progress,
        _ => null,
      },
      actions: [
        if (copy.phase == CopyPhase.failed || copy.phase == CopyPhase.cancelled)
          MTLinkButton(label: l.retry, onPressed: () => copies.retry(copy.id)),
        if (copy.phase == CopyPhase.done)
          if (copy.path case final path?)
            MTLinkButton(
              label: l.desktopShowInFolder,
              onPressed: () =>
                  unawaited(ref.read(desktopFoldersProvider).reveal(path)),
            ),
      ],
      onClose: copy.isActive ? () => copies.cancel(copy.id) : null,
    );
  }
}
