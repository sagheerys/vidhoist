import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../shared/open_web_link.dart';

/// When a star may be asked for, kept in the same store as the settings.
final starAskProvider = Provider<StarAsk>(
  (ref) => StarAsk(ref.watch(keyValueStoreProvider)),
);

/// Opens one of the question's two pages in the browser.
final starPageOpenerProvider = Provider<Future<void> Function(String url)>(
  (ref) => openWebLink,
);

/// Goes up by one after each finished download is counted, so the
/// library checks again whether the question is due.
final finishedCountedProvider = StateProvider<int>((ref) => 0);

/// Counts a finished download for the star question.
Future<void> countFinishedDownload(Ref ref) async {
  await ref.read(starAskProvider).countFinished();
  ref.read(finishedCountedProvider.notifier).state++;
}

/// **The star question on the phone: a sheet over the library**, once the
/// third download has finished, and never over anything else: not over
/// another sheet or a player, not on another tab. It waits a moment, so
/// that the clip just arrived is seen lit in the library first.
///
/// Swiped away, it is "Maybe later". A star or "Don't show this again"
/// ends it; [StarAsk] decides when it is due.
class StarAskPrompt extends ConsumerStatefulWidget {
  const StarAskPrompt({super.key, required this.child});

  final Widget child;

  /// How long the library is left to itself after a download arrives.
  static const settle = Duration(seconds: 2);

  @override
  ConsumerState<StarAskPrompt> createState() => _StarAskPromptState();
}

class _StarAskPromptState extends ConsumerState<StarAskPrompt> {
  bool _open = false;
  Timer? _wait;

  @override
  void initState() {
    super.initState();
    ref.listenManual(finishedCountedProvider, (_, _) => _soon());
  }

  @override
  void dispose() {
    _wait?.cancel();
    super.dispose();
  }

  void _soon() {
    _wait?.cancel();
    _wait = Timer(StarAskPrompt.settle, () => unawaited(_look()));
  }

  Future<void> _look() async {
    if (_open || !mounted) return;
    final ask = ref.read(starAskProvider);
    if (!await ask.isDue() || !mounted) return;
    if (VhRouteDepth.depth.value != 0) return;
    final here = GoRouter.of(context).routerDelegate.currentConfiguration;
    if (here.uri.path != '/') return;
    await ask.shown();
    if (!mounted) return;
    _open = true;
    final answer = await showVhSheet<_Answer>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.xl,
            0,
            VhSpace.xl,
            VhSpace.lg,
          ),
          child: VhStarAsk(
            onStar: () => Navigator.pop(context, _Answer.star),
            onIdeas: () => Navigator.pop(context, _Answer.ideas),
            onLater: () => Navigator.pop(context),
            onNever: () => Navigator.pop(context, _Answer.never),
          ),
        ),
      ),
    );
    _open = false;
    final open = ref.read(starPageOpenerProvider);
    switch (answer) {
      case _Answer.star:
        unawaited(open(StarAsk.repoUrl));
        await ask.end();
      case _Answer.ideas:
        unawaited(open(StarAsk.ideasUrl));
      case _Answer.never:
        await ask.end();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

enum _Answer { star, ideas, never }
