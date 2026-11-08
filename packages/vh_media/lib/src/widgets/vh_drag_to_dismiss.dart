import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A vertical drag closes the screen**: the content follows the finger
/// downwards, never upwards, and on release it either closes, if the
/// distance passes [VhMotion.dismissDragDistance] or the velocity passes
/// [VhMotion.dismissFlingVelocity], or returns calmly to place.
///
/// **It competes with nothing**: the progress bar drags horizontally and
/// the buttons are tapped, and only `onVerticalDragUpdate` is used here.
/// When the system asks to reduce motion, dismissal works without the
/// visual tracking.
class VhDragToDismiss extends StatefulWidget {
  const VhDragToDismiss({super.key, required this.child});

  final Widget child;

  @override
  State<VhDragToDismiss> createState() => _VhDragToDismissState();
}

class _VhDragToDismissState extends State<VhDragToDismiss>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: VhMotion.tap,
  )..addListener(() => setState(() => _offset = _settle.value * _from));

  double _offset = 0;
  double _from = 0;

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onUpdate(DragUpdateDetails d) {
    if (_settle.isAnimating) _settle.stop();
    setState(() => _offset = (_offset + d.delta.dy).clamp(0, double.infinity));
  }

  void _onEnd(DragEndDetails d) {
    final velocity = d.velocity.pixelsPerSecond.dy;
    if (_offset > VhMotion.dismissDragDistance ||
        velocity > VhMotion.dismissFlingVelocity) {
      Navigator.of(context).maybePop();
      return;
    }
    // A calm return to place, with no bounce.
    _from = _offset;
    _settle
      ..value = 1
      ..animateTo(0, curve: VhMotion.entrance);
  }

  @override
  Widget build(BuildContext context) {
    final follow = !MediaQuery.disableAnimationsOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: Transform.translate(
        offset: Offset(0, follow ? _offset : 0),
        child: widget.child,
      ),
    );
  }
}
