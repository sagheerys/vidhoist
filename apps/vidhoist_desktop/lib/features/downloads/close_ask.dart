import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/close_guard.dart';
import '../../data/downloads_data.dart';
import '../../data/notices.dart';
import '../library/pending_clip.dart';

/// The downloads a close would stop: running or waiting their turn. A
/// paused one is left out, since nothing of it is going on.
List<DownloadTask> downloadsACloseStops(List<DownloadTask> tasks) => [
  for (final t in tasks)
    if (!t.isFinished && t.phase != TaskPhase.paused) t,
];

/// **Asks before the user's close stops downloads.** Nothing is lost by
/// closing (they go on at the next start), but a close made without
/// noticing a long download costs the time it already ran, so the app
/// says what is still going and lets the user keep it open.
///
/// Never asked when nothing is downloading, when the close sends the
/// window to the tray, or when Windows itself shuts down.
class CloseAskWiring extends ConsumerStatefulWidget {
  const CloseAskWiring({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CloseAskWiring> createState() => _CloseAskWiringState();
}

class _CloseAskWiringState extends ConsumerState<CloseAskWiring> {
  late final CloseGuard _guard;
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    _guard = ref.read(closeGuardProvider)..ask = _ask;
  }

  @override
  void dispose() {
    if (_guard.ask == _ask) _guard.ask = null;
    super.dispose();
  }

  Future<bool> _ask() async {
    final going = downloadsACloseStops(
      ref.read(engineTasksProvider).valueOrNull ?? const [],
    );
    if (going.isEmpty || !mounted) return true;
    // A second close while the question is up is the same question.
    if (_asking) return false;
    _asking = true;
    try {
      // From the tray the window may be hidden: the question needs it.
      await ref.read(bringWindowBackProvider)();
      if (!mounted) return true;
      final l = context.vhl;
      final first = going.first;
      return await showVhConfirm(
        context,
        title: l.desktopCloseTitle(going.length),
        message: l.desktopCloseBody(going.length),
        confirmLabel: l.desktopCloseAnyway,
        cancelLabel: l.desktopCloseKeep,
        preview: VhDialogClip(
          title: vhName(pendingName(first)),
          thumbnail: HeldCover(task: first, width: 44, height: 28),
          progress: first.hasKnownProgress ? first.progress : null,
          note: going.length > 1 ? l.desktopCloseMore(going.length - 1) : null,
        ),
      );
    } finally {
      _asking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
