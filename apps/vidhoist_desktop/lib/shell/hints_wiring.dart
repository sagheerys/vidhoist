import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/desktop_habits.dart';
import '../data/hints_data.dart';
import '../data/notices.dart';
import '../di.dart';
import '../features/shortcuts/shortcuts_sheet.dart';
import 'shell_state.dart';

/// **The two tips' moments**, for the life of the shell: the shortcuts a
/// few seconds into the first clip that plays, in the window's corner; and
/// the icon by the clock the first time the window closes to it, as a
/// Windows notice, since the window is gone by then. [Hints] decides
/// whether each may show.
class HintsWiring extends ConsumerStatefulWidget {
  const HintsWiring({super.key, required this.child});

  final Widget child;

  /// How long a clip plays before the shortcuts tip: past its start, when
  /// the eye is free again.
  static const settle = Duration(seconds: 4);

  @override
  ConsumerState<HintsWiring> createState() => _HintsWiringState();
}

class _HintsWiringState extends ConsumerState<HintsWiring> {
  StreamSubscription<VhPlayerState>? _states;
  ValueListenable<int>? _closes;
  Timer? _soon;

  @override
  void initState() {
    super.initState();
    // Read from the store now, long before the first clip plays.
    ref.read(hintsProvider);
    _states = ref.read(playerProvider).states.listen(_onState);
    _closes = ref.read(windowControlsProvider).closeRequests
      ..addListener(_onClose);
  }

  @override
  void dispose() {
    _soon?.cancel();
    unawaited(_states?.cancel());
    _closes?.removeListener(_onClose);
    super.dispose();
  }

  void _onState(VhPlayerState state) {
    if (_soon != null || !state.playing || state.current == null) return;
    if (!ref.read(hintsProvider.notifier).wants(DesktopHint.shortcuts)) return;
    _soon = Timer(HintsWiring.settle, _offerShortcuts);
  }

  void _offerShortcuts() {
    _soon = null;
    if (!mounted) return;
    final hints = ref.read(hintsProvider.notifier);
    final controls = ref.read(windowControlsProvider);
    // Not over a picture filling the screen, nor in the small card, nor
    // once the clip has stopped: the next play is another moment.
    if (!hints.wants(DesktopHint.shortcuts) ||
        controls.fullScreen.value ||
        controls.mini.value ||
        !ref.read(playerProvider).state.playing) {
      return;
    }
    unawaited(hints.shown(DesktopHint.shortcuts));
    final l = context.vhl;
    showVhNotice(
      context,
      message: l.desktopHintShortcuts,
      icon: VhIcons.info,
      actionLabel: l.desktopHintShortcutsAction,
      onAction: () {
        if (mounted) unawaited(showShortcutsSheet(context));
      },
      duration: const Duration(seconds: 8),
    );
  }

  void _onClose() {
    if (!mounted || !ref.read(closeToTrayProvider)) return;
    final hints = ref.read(hintsProvider.notifier);
    if (!hints.wants(DesktopHint.tray)) return;
    unawaited(hints.shown(DesktopHint.tray));
    final l = context.vhl;
    unawaited(
      ref
          .read(noticePortProvider)
          .show(
            DesktopNotice(
              title: l.desktopHintTrayTitle,
              body: l.desktopHintTrayBody,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
