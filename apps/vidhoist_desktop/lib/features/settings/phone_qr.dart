import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:vh_ui/vh_ui.dart';

/// The pairing QR code. Always near-black on white, in either theme: phone
/// cameras read dark modules on a light ground, and an inverted code fails
/// on many of them.
class PhoneQr extends StatelessWidget {
  const PhoneQr({super.key, required this.data, this.size = 168});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    final image = QrImage(
      QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M),
    );
    return Semantics(
      image: true,
      label: context.vhl.pcLinkQrHint,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _QrPainter(data, image)),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data, this.image);

  final String data;
  final QrImage image;

  /// The quiet margin a reader needs around the code, in modules.
  static const _margin = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final count = image.moduleCount + 2 * _margin;
    final cell = size.shortestSide / count;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(cell * 2)),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    final dark = Paint()..color = const Color(0xFF111111);
    for (var row = 0; row < image.moduleCount; row++) {
      for (var col = 0; col < image.moduleCount; col++) {
        if (!image.isDark(row, col)) continue;
        // A hair wider than a cell, so neighbours join without seams.
        canvas.drawRect(
          Rect.fromLTWH(
            (col + _margin) * cell,
            (row + _margin) * cell,
            cell + 0.5,
            cell + 0.5,
          ),
          dark,
        );
      }
    }
  }

  @override
  // The countdown rebuilds the card each second; the code is the same.
  bool shouldRepaint(_QrPainter old) => old.data != data;
}
