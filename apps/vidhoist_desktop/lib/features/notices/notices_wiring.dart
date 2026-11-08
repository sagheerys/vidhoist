import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/choices_data.dart';
import '../../data/downloads_data.dart';
import '../../data/folders_data.dart';
import '../../data/library_data.dart';
import '../../data/notices.dart';
import '../../di.dart';
import '../../router.dart';
import '../../shell/error_text.dart';
import '../../shell/hints_wiring.dart';

/// **Windows notifications** for what ends while the window is away: a
/// download done or failed. In front, the downloads panel says it already,
/// so nothing is shown. A finished file also opens Explorer on itself when
/// "Show in Explorer when done" is on, in front or not.
class NoticesWiring extends ConsumerStatefulWidget {
  const NoticesWiring({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NoticesWiring> createState() => _NoticesWiringState();
}

class _NoticesWiringState extends ConsumerState<NoticesWiring> {
  final _phases = <String, TaskPhase>{};

  @override
  void initState() {
    super.initState();
    // Built now, so its saved value is read before the first download ends:
    // built at that moment, it would still answer its default.
    ref.listenManual(revealAfterDownloadProvider, (_, _) {});
    ref.listenManual(
      engineTasksProvider,
      (_, next) => _onTasks(next.valueOrNull ?? const []),
      fireImmediately: true,
    );
  }

  void _onTasks(List<DownloadTask> tasks) {
    final ended = newlyEnded(_phases, tasks);
    _phases
      ..clear()
      ..addAll({for (final task in tasks) task.id: task.phase});
    for (final task in ended) {
      unawaited(_show(_forTask(task)));
      if (task.phase == TaskPhase.completed &&
          ref.read(revealAfterDownloadProvider)) {
        if (task.localPath case final path?) {
          unawaited(ref.read(desktopFoldersProvider).reveal(path));
        }
      }
    }
  }

  DesktopNotice? _forTask(DownloadTask task) {
    if (!mounted) return null;
    final l = context.vhl;
    final name = task.title ?? task.inputUrl;
    final url = task.canonicalUrl;
    if (task.phase == TaskPhase.failed) {
      return DesktopNotice(
        title: l.downloadFailed,
        // The reason in the notice itself: "failed" alone leaves a dropped
        // network, a refused link and a full disk to guesswork.
        body:
            '$name · ${task.error == null ? l.failed : errorText(l, task.error!)}',
      );
    }
    return DesktopNotice(
      title: l.downloadComplete,
      body: name,
      actions: [
        if (url != null)
          (label: l.play, onPressed: () => unawaited(_play(url))),
      ],
      onClick: url == null ? null : () => unawaited(_open(url)),
    );
  }

  Future<void> _show(DesktopNotice? notice) async {
    if (notice == null) return;
    if (await ref.read(windowInFrontProvider)()) return;
    await ref.read(noticePortProvider).show(notice);
  }

  Future<void> _open(String canonicalUrl) async {
    await ref.read(bringWindowBackProvider)();
    if (mounted) GoRouter.of(context).go(DesktopRoutes.item(canonicalUrl));
  }

  Future<void> _play(String canonicalUrl) async {
    await _open(canonicalUrl);
    final items = ref.read(libraryItemsProvider).valueOrNull ?? const [];
    final item = items.where((i) => i.canonicalUrl == canonicalUrl).firstOrNull;
    if (item == null) return;
    await ref.read(playerProvider).playItems([toPlaylistItem(item)]);
  }

  @override
  // The app's two tips come from here too.
  Widget build(BuildContext context) => HintsWiring(child: widget.child);
}
