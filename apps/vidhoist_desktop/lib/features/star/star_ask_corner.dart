import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../../shell/open_web_link.dart';
import '../../shell/shell_metrics.dart';

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
Future<void> countFinishedDownload(WidgetRef ref) async {
  await ref.read(starAskProvider).countFinished();
  ref.read(finishedCountedProvider.notifier).state++;
}

/// **The star question on the computer: a small card in the library's far
/// corner**, above the player bar. It covers nothing being used: the
/// library goes on working beside it, and it is never put over a dialog
/// or in full screen, where the library is not in front.
///
/// The cross and Esc close it as "Maybe later". A star or "Don't show this
/// again" ends it; [StarAsk] decides when it is due.
class StarAskCorner extends ConsumerStatefulWidget {
  const StarAskCorner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<StarAskCorner> createState() => _StarAskCornerState();
}

class _StarAskCornerState extends ConsumerState<StarAskCorner> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      finishedCountedProvider,
      (_, _) => unawaited(_look()),
      fireImmediately: true,
    );
  }

  Future<void> _look() async {
    if (_shown) return;
    final ask = ref.read(starAskProvider);
    if (!await ask.isDue() || !mounted) return;
    // Not under a dialog: the question waits for the library to be in
    // front again.
    if (!_inFront(context)) return;
    await ask.shown();
    if (mounted) setState(() => _shown = true);
  }

  void _close() => setState(() => _shown = false);

  /// Whether nothing stands over the library: its page is the top of the
  /// shell's navigator, and the shell the top of the window's, where the
  /// dialogs open.
  static bool _inFront(BuildContext context) {
    BuildContext? at = context;
    while (at != null) {
      if (ModalRoute.of(at)?.isCurrent == false) return false;
      at = at.findAncestorStateOfType<NavigatorState>()?.context;
    }
    return true;
  }

  void _open(String url, {bool end = false}) {
    unawaited(ref.read(starPageOpenerProvider)(url));
    if (end) unawaited(ref.read(starAskProvider).end());
    _close();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      PositionedDirectional(
        end: VhSpace.lg,
        bottom: VhSpace.lg,
        child: AnimatedSwitcher(
          duration: vhMotionDuration(context, VhMotion.medium),
          switchInCurve: VhMotion.entrance,
          switchOutCurve: VhMotion.exit,
          child: !_shown
              ? const SizedBox.shrink()
              : CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.escape): _close,
                  },
                  child: Focus(autofocus: true, child: _card(context)),
                ),
        ),
      ),
    ],
  );

  Widget _card(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Material(
      color: p.card,
      elevation: VhSpace.md,
      shadowColor: VhPalette.fullscreenScrim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VhRadius.card),
        side: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DesktopShellSize.starCard),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.lg,
            VhSpace.sm,
            VhSpace.lg,
            VhSpace.md,
          ),
          child: VhStarAsk(
            card: true,
            onStar: () => _open(StarAsk.repoUrl, end: true),
            onIdeas: () => _open(StarAsk.ideasUrl),
            onLater: _close,
            onNever: () {
              unawaited(ref.read(starAskProvider).end());
              _close();
            },
          ),
        ),
      ),
    );
  }
}
