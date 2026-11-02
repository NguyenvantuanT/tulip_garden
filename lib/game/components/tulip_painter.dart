import 'package:flutter/material.dart';

import '../../src/resources/app_color.dart';
import '../growth.dart';

class TulipPainter {
  TulipPainter._();

  static final Paint _bulbPaint = Paint()..color = AppColor.bulb;
  static final Paint _leafPaint = Paint()..color = AppColor.leaf;
  static final Paint _petalPaint = Paint()..color = AppColor.petal;
  static final Paint _stemPaint = Paint()
    ..color = AppColor.leafDark
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static void paint(Canvas canvas, Size size, GrowthStage stage) {
    final width = size.width;
    final base = Offset(width / 2, size.height * 0.82);
    _stemPaint.strokeWidth = width * 0.05;
    switch (stage) {
      case GrowthStage.bulb:
        canvas.drawOval(
          Rect.fromCenter(
            center: base.translate(0, -width * 0.1),
            width: width * 0.3,
            height: width * 0.24,
          ),
          _bulbPaint,
        );
      case GrowthStage.sprout:
        _drawStem(canvas, base, width * 0.22);
        _drawLeaf(canvas, base, width * 0.24, -0.5);
        _drawLeaf(canvas, base, width * 0.2, 0.55);
      case GrowthStage.bud:
        final top = _drawStem(canvas, base, width * 0.46);
        _drawLeaf(canvas, base, width * 0.34, -0.45);
        _drawLeaf(canvas, base, width * 0.3, 0.5);
        canvas.drawOval(
          Rect.fromCenter(
            center: top.translate(0, -width * 0.08),
            width: width * 0.16,
            height: width * 0.24,
          ),
          _petalPaint,
        );
      case GrowthStage.bloom:
        final top = _drawStem(canvas, base, width * 0.44);
        _drawLeaf(canvas, base, width * 0.38, -0.45);
        _drawLeaf(canvas, base, width * 0.34, 0.5);
        _drawCup(canvas, top.translate(0, -width * 0.1), width * 0.17);
    }
  }

  static Offset _drawStem(Canvas canvas, Offset base, double length) {
    final top = base.translate(0, -length);
    canvas.drawLine(base, top, _stemPaint);
    return top;
  }

  static void _drawLeaf(
    Canvas canvas,
    Offset base,
    double length,
    double angle,
  ) {
    canvas
      ..save()
      ..translate(base.dx, base.dy)
      ..rotate(angle)
      ..drawOval(
        Rect.fromLTWH(-length * 0.18, -length, length * 0.36, length),
        _leafPaint,
      )
      ..restore();
  }

  static void _drawCup(Canvas canvas, Offset center, double radius) {
    final x = center.dx;
    final y = center.dy;
    final path = Path()
      ..moveTo(x - radius, y - radius)
      ..lineTo(x - radius * 0.4, y - radius * 0.4)
      ..lineTo(x, y - radius * 1.1)
      ..lineTo(x + radius * 0.4, y - radius * 0.4)
      ..lineTo(x + radius, y - radius)
      ..quadraticBezierTo(x + radius, y + radius, x, y + radius)
      ..quadraticBezierTo(x - radius, y + radius, x - radius, y - radius)
      ..close();
    canvas.drawPath(path, _petalPaint);
  }
}
