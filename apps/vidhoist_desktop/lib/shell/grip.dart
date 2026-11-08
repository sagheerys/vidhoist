import 'package:flutter/widgets.dart';
import 'package:vh_ui/vh_ui.dart';

/// Six small dots, the grip a line is dragged by. Drawn rather than taken
/// from Material, whose handle is one of its icons.
class DesktopGrip extends StatelessWidget {
  const DesktopGrip({super.key});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Grip(VhThemeX.of(context).palette.ink3));
}

class _Grip extends CustomPainter {
  const _Grip(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final c = size.center(Offset.zero);
    const gap = VhSpace.xxs;
    for (final dx in [-gap / 2, gap / 2]) {
      for (final dy in [-gap, 0.0, gap]) {
        canvas.drawCircle(c + Offset(dx, dy), gap / 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_Grip old) => old.color != color;
}
