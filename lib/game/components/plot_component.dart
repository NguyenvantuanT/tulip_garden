import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../src/resources/app_color.dart';
import '../clock.dart';
import '../garden_layout.dart';
import '../garden_state.dart';
import 'tulip_painter.dart';

class PlotComponent extends PositionComponent with TapCallbacks {
  PlotComponent({
    required this.garden,
    required this.gardenPosition,
    required this.layout,
    required this.clock,
  });

  final GardenState garden;
  final GardenPosition gardenPosition;
  final GardenLayout layout;
  final Clock clock;

  static final Paint _soilPaint = Paint()..color = AppColor.soil;
  static final Paint _edgePaint = Paint()
    ..color = AppColor.soilEdge
    ..style = PaintingStyle.stroke;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final rect = layout.plotRect(size.toSize(), gardenPosition);
    position = Vector2(rect.left, rect.top);
    this.size = Vector2(rect.width, rect.height);
  }

  @override
  void onTapUp(TapUpEvent event) {
    garden.tap(gardenPosition, clock());
  }

  @override
  void render(Canvas canvas) {
    final radius = Radius.circular(size.x * 0.12);
    final rect = RRect.fromRectAndRadius(size.toRect(), radius);
    _edgePaint.strokeWidth = size.x * 0.04;
    canvas
      ..drawRRect(rect, _soilPaint)
      ..drawRRect(rect.deflate(_edgePaint.strokeWidth / 2), _edgePaint);
    final stage = garden.plotAt(gardenPosition).stageAt(clock());
    if (stage != null) {
      TulipPainter.paint(canvas, size.toSize(), stage);
    }
  }
}
