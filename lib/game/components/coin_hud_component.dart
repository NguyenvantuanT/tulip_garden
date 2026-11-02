import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../src/resources/app_color.dart';
import '../garden_state.dart';

class CoinHudComponent extends PositionComponent {
  CoinHudComponent({required this.garden})
    : super(position: Vector2.all(16), size: Vector2(200, _iconSize));

  static const double _iconSize = 32;

  final GardenState garden;

  static final Paint _coinPaint = Paint()..color = AppColor.coin;
  static final Paint _edgePaint = Paint()
    ..color = AppColor.coinEdge
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  late final TextComponent _label = TextComponent(
    position: Vector2(_iconSize + 10, _iconSize / 2),
    anchor: Anchor.centerLeft,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: AppColor.leafDark,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  String get displayedText => _label.text;

  @override
  Future<void> onLoad() async {
    _label.text = '${garden.coins}';
    add(_label);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _label.text = '${garden.coins}';
  }

  @override
  void render(Canvas canvas) {
    const center = Offset(_iconSize / 2, _iconSize / 2);
    canvas
      ..drawCircle(center, _iconSize / 2, _coinPaint)
      ..drawCircle(center, _iconSize / 2 - 1.5, _edgePaint)
      ..drawCircle(center, _iconSize / 4, _edgePaint);
  }
}
