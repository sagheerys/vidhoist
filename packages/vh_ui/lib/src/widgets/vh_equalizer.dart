import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';

/// The "now playing" indicator: four swaying bars in the accent colour.
class VhEqualizer extends StatefulWidget {
  const VhEqualizer({super.key, this.size = 14, this.animate = true});

  final double size;
  final bool animate;

  @override
  State<VhEqualizer> createState() => _VhEqualizerState();
}

class _VhEqualizerState extends State<VhEqualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    // One full sway, up and back, as the old there-and-back pair took.
    duration: const Duration(seconds: 2),
  );

  static const _heights = [6.0, 13.0, 9.0, 12.0];

  /// Sways while playing, unless the system asks for no animation: then
  /// the bars stand still at their own heights, which still say "this
  /// one".
  void _drive() {
    if (widget.animate && !MediaQuery.disableAnimationsOf(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _drive();
  }

  /// **It actually stops when playback pauses**, or the effect keeps running
  /// after the clip stopped and suggests it is still playing. The flag was only
  /// read in `initState`, so changing it later did not stop the controller,
  /// which went on rebuilding sixty times a second over a silent clip.
  @override
  void didUpdateWidget(VhEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) _drive();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = VhThemeX.of(context).palette.accent;
    final scale = widget.size / 14;
    return SizedBox(
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) SizedBox(width: 2.5 * scale),
              _bar(i, accent, scale),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bar(int i, Color accent, double scale) {
    final t = widget.animate ? vhEqualizerSway(_controller.value, i) : 1.0;
    final factor = 0.45 + 0.55 * t;
    return Container(
      width: 3 * scale,
      height: _heights[i] * scale * factor,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(2 * scale),
      ),
    );
  }
}

/// How far bar [bar] stands (0 to 1) at [t] of one sway.
///
/// **A wave, not a remainder**: the bars were offset with `% 1.0` on a
/// controller running there and back, so each crossed from 1 to 0 in a
/// single frame once a sweep and three of the four bars snapped short. A
/// cosine returns where it began, so the loop has no seam.
double vhEqualizerSway(double t, int bar) {
  const delays = [0.0, 0.2, 0.4, 0.1];
  return 0.5 - 0.5 * math.cos(2 * math.pi * (t + delays[bar]));
}
