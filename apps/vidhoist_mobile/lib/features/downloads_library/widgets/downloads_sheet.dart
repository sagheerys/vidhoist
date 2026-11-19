import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../../di.dart';
import '../../home/add_flow.dart';
import '../../home/network_gate.dart';
import '../../settings/settings_sections.dart';
import 'task_card_parts.dart';

/// The "manage downloads" sheet: in progress, waiting, needs your
/// attention, with cancel and retry.
void showDownloadsSheet(BuildContext context) {
  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    // **It does not rise into the camera cutout**: without this the sheet
    // started at the very top of the screen, so the drag handle disappeared
    // under the status bar and there was nothing left to grab to pull it
    // down.
    useSafeArea: true,
    builder: (_) => const _DownloadsSheet(),
  );
}

class _DownloadsSheet extends ConsumerStatefulWidget {
  const _DownloadsSheet();

  @override
  ConsumerState<_DownloadsSheet> createState() => _DownloadsSheetState();
}

class _DownloadsSheetState extends ConsumerState<_DownloadsSheet> {
  /// Whether the sheet has shown any work. From then on it keeps its frame
  /// when the last task finishes or is dismissed: the bare empty state is
  /// centred in all the height a scroll-controlled sheet allows, so the
  /// sheet used to leap to the top of the screen the moment the list
  /// emptied.
  bool _framed = false;

  /// Tasks that finished while the sheet was open: each stays a moment
  /// with its check drawn, then folds away, rather than vanishing.
  final Map<String, DownloadTask> _finishing = {};
  Set<String> _wasRunning = const {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final tasks = ref.watch(engineTasksProvider).valueOrNull ?? const [];
    final engine = ref.read(downloadEngineProvider);
    final wifiPaused = ref.watch(wifiPausedProvider);

    final running = tasks
        .where((t) => !t.isFinished && t.phase != TaskPhase.queued)
        .toList();
    for (final task in tasks) {
      if (task.phase == TaskPhase.completed && _wasRunning.contains(task.id)) {
        _finishing.putIfAbsent(task.id, () => task);
      }
    }
    _wasRunning = {for (final task in running) task.id};
    final finishing = _finishing.values.toList();
    final queued = tasks.where((t) => t.phase == TaskPhase.queued).toList();
    final failed = tasks.where((t) => t.phase == TaskPhase.failed).toList();

    Widget section(
      String title,
      List<DownloadTask> sectionTasks, {
      bool error = false,
    }) {
      if (sectionTasks.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VhSectionHeader(title: title, trailing: '${sectionTasks.length}'),
          const SizedBox(height: VhSpace.sm),
          for (final (index, task) in sectionTasks.indexed) ...[
            if (_finishing.containsKey(task.id))
              VhFoldAway(
                key: ValueKey('done-${task.id}'),
                onGone: () => setState(() => _finishing.remove(task.id)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: VhSpace.xs),
                  child: VhDownloadProgressCard(
                    title: task.title ?? task.effectiveUrl,
                    thumbnail: taskThumbnail(task),
                    statusText: l10n.completed,
                    done: true,
                  ),
                ),
              )
            else
              VhDownloadProgressCard(
                // A new task or a new phase starts its own count: a phase's
                // bar begins at 0 and must not run down from the last 100%.
                key: ValueKey('${task.id}-${task.phase.name}'),
                // yt-dlp's title once it has one, not the bare link.
                title: task.title ?? task.effectiveUrl,
                thumbnail: taskThumbnail(task),
                detail: taskSpeed(task),
                waiting: task.phase == TaskPhase.queued,
                statusText: error
                    ? taskErrorText(l10n, task)
                    : task.phase == TaskPhase.queued
                    // Its place in the line, counted in this section.
                    ? l10n.queuePosition(index + 1)
                    : taskStatusText(
                        l10n,
                        task,
                        waitingForWifi: wifiPaused.contains(task.id),
                      ),
                progress: task.hasKnownProgress ? task.progress : null,
                isError: error,
                action: error ? null : taskCardAction(l10n, task, engine),
                // **A failed task is dismissed with the same close button**:
                // a failed download could not be removed from the list.
                // `onCancel` was null on an error, so the close mark
                // disappeared and only
                // "retry" was left, and the card sat in "needs your
                // attention" until the app was killed. `forget` had been in
                // the engine all along and nothing in the interface called
                // it.
                onCancel: () {
                  if (error) {
                    engine?.forget(task.id);
                  } else {
                    engine?.cancel(task.id);
                  }
                },
              ),
            // Wrapping, not a row: two buttons in a longer language at a
            // large text size did not fit one line.
            if (error)
              Wrap(
                alignment: WrapAlignment.end,
                children: [
                  // A site that wants a sign-in gets the page that does it,
                  // beside the retry that will work once it is done.
                  if (task.error is PlatformBlockedException)
                    TextButton(
                      onPressed: () {
                        final router = GoRouter.of(context);
                        Navigator.pop(context);
                        router.go(SettingsPane.accounts.route);
                      },
                      child: Text(l10n.accountSignIn),
                    ),
                  TextButton(
                    onPressed: () {
                      engine?.submit(
                        task.effectiveUrl,
                        task.quality,
                        clip: task.clip,
                      );
                      // The old card does not linger beside the new
                      // attempt.
                      engine?.forget(task.id);
                      Navigator.pop(context);
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            const SizedBox(height: VhSpace.xs),
          ],
          const SizedBox(height: VhSpace.md),
        ],
      );
    }

    final shown = tasks.where(
      (t) => !t.isFinished || t.phase == TaskPhase.failed,
    );
    final empty = VhEmptyState(
      title: l10n.noDownloads,
      message: l10n.allDownloadsFinished,
    );
    final nothing = shown.isEmpty && finishing.isEmpty;
    if (nothing && !_framed) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          VhSpace.xl,
          VhSpace.lg,
          VhSpace.xl,
          vhSheetBottomPad(context, VhSpace.xxl),
        ),
        // The column lets the centred state take its own height rather
        // than the whole screen.
        child: Column(mainAxisSize: MainAxisSize.min, children: [empty]),
      );
    }
    _framed = true;

    // **A fixed height with a scrolling list**: the sheet sat right at the
    // top where it could not be dragged down, and shrank every time a video
    // finished.
    // `ListView(shrinkWrap: true)` made the sheet's height equal its
    // content's: seven tasks filled the screen, then it jumped upward with
    // every completion. The sheet now opens at 62% and drags between 35%
    // and 85% however the count changes, and only the list scrolls.
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.fromLTRB(
          VhSpace.xl,
          VhSpace.lg,
          VhSpace.xl,
          vhSheetBottomPad(context, VhSpace.xxl),
        ),
        // **The title is pinned and only the list scrolls**: it used to be
        // the first item in the `ListView`, so
        // it scrolled away with the content and vanished once there were
        // many downloads, leaving a list scrolling with no header to say
        // what it is.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.activeDownloadsSheet,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: VhSpace.lg),
            Expanded(
              // The message scrolls rather than overflows when the sheet
              // is dragged low or the window is short (a tablet on its side),
              // and stays attached to the controller so the sheet still drags.
              child: nothing
                  ? LayoutBuilder(
                      builder: (context, box) => SingleChildScrollView(
                        controller: scrollController,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: box.maxHeight),
                          child: Center(child: empty),
                        ),
                      ),
                    )
                  : ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        section(l10n.activeNow, [...running, ...finishing]),
                        section(l10n.queuedSection, queued),
                        section(l10n.needsAttention, failed, error: true),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
