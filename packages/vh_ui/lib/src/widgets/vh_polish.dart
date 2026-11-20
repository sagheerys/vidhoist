import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';
import '../tokens/tokens.dart';
import 'vh_desktop_app.dart';

/// **Light touches of motion** on some icons, consistent and suited to
/// both apps.
///
/// Three small components used by both apps. All of them take their
/// durations from [VhMotion], none of them bounces (`elasticOut` and
/// `bounceOut` are forbidden), and all of them switch themselves off
/// when the system asks to reduce motion.

/// The effective duration: zero when the system asks to reduce motion.
Duration vhMotionDuration(BuildContext context, Duration duration) =>
    MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

/// **A light shrink while pressed**, which says "this is a button" before
/// it does anything.
///
/// It wraps `InkWell` rather than replacing it: the ripple stays and the
/// shrink is added. It listens at the pointer level rather than through a
/// `GestureDetector`, so it never competes for the tap.
class VhPressable extends StatefulWidget {
  const VhPressable({
    super.key,
    required this.child,
    this.enabled = true,
    this.scale = VhMotion.pressScale,
  });

  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<VhPressable> createState() => _VhPressableState();
}

class _VhPressableState extends State<VhPressable> {
  bool _down = false;

  void _set(bool down) {
    if (_down == down || !widget.enabled) return;
    setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.deferToChild,
    onPointerDown: (_) => _set(true),
    onPointerUp: (_) => _set(false),
    onPointerCancel: (_) => _set(false),
    child: AnimatedScale(
      scale: _down ? widget.scale : 1,
      duration: vhMotionDuration(context, VhMotion.tap),
      // Decisive on the way down, calm on the way back up.
      curve: _down ? VhMotion.exit : VhMotion.entrance,
      child: widget.child,
    ),
  );
}

/// **Swapping an icon in place**: the old one fades while shrinking and the
/// new one grows from [VhMotion.iconSwapScale] to full size. No jump
/// between play and pause, or between an empty and a filled heart.
///
/// The icon itself is the key, so nothing animates unless it changes.
class VhIconSwap extends StatelessWidget {
  const VhIconSwap({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
    this.shadows,
    this.matchTextDirection = false,
  });

  final VhIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final List<Shadow>? shadows;
  final bool matchTextDirection;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: vhMotionDuration(context, VhMotion.tap),
    switchInCurve: VhMotion.entrance,
    switchOutCurve: VhMotion.exit,
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: VhMotion.iconSwapScale,
          end: 1,
        ).animate(animation),
        child: child,
      ),
    ),
    child: VhIcon(
      icon,
      key: ValueKey(icon.name),
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      shadows: shadows,
      matchTextDirection: matchTextDirection,
    ),
  );
}

/// What an item's thumbnail shows when it has no cover: on the phones a
/// music note, as always; in the Windows app the headphones for audio and
/// the clip mark for video.
Widget vhCoverPlaceholder(
  BuildContext context, {
  required double size,
  required Color color,
  bool audio = false,
}) => Center(
  child: VhIcon(
    VhDesktopApp.isDesktop(context)
        ? (audio ? VhIcons.headphones : VhIcons.library)
        : VhIcons.music,
    size: size,
    color: color,
  ),
);

/// **A "rising sheet" transition**: the screen rises whole from the bottom
/// while the one beneath it dims slightly. For screens that expand out of a
/// bottom element, such as the mini player opening the audio screen. Going
/// back reverses it, so it looks like it returned where it came from.
///
/// Used with `CustomTransitionPage` in the route table. It does not replace
/// the horizontal screen transition used everywhere else.
Widget vhSheetPageTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  if (MediaQuery.disableAnimationsOf(context)) return child;
  final rise = CurvedAnimation(
    parent: animation,
    curve: VhMotion.entrance,
    reverseCurve: VhMotion.exit,
  );
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(rise),
    child: child,
  );
}

/// **The chosen place's icon gives a short pulse** as it fills: a little
/// smaller, a little larger, then still, in under a quarter of a second.
/// It says "you are here now" where the fill alone changed in a frame.
///
/// It plays when [active] turns on, and on its first frame too when
/// [onMount] (the rail builds the chosen icon afresh each time). The
/// system's "remove animations" leaves the icon still.
class VhChosenPulse extends StatefulWidget {
  const VhChosenPulse({
    super.key,
    required this.active,
    required this.child,
    this.onMount = false,
  });

  final bool active;
  final bool onMount;
  final Widget child;

  /// The whole pulse; long enough to be seen, short enough not to wait on.
  static const duration = Duration(milliseconds: 240);

  @override
  State<VhChosenPulse> createState() => _VhChosenPulseState();
}

class _VhChosenPulseState extends State<VhChosenPulse>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: VhChosenPulse.duration,
    value: 1,
  );

  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.82,
        end: 1.1,
      ).chain(CurveTween(curve: VhMotion.entrance)),
      weight: 60,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.1,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
  ]).animate(_controller);

  @override
  void initState() {
    super.initState();
    if (widget.active && widget.onMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play());
    }
  }

  @override
  void didUpdateWidget(VhChosenPulse old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _play();
  }

  void _play() {
    if (!mounted ||
        vhMotionDuration(context, VhChosenPulse.duration) == Duration.zero) {
      return;
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _scale, child: widget.child);
}
