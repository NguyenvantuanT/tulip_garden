import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../src/resources/app_color.dart';

class TulipGardenGame extends FlameGame {
  @override
  Color backgroundColor() => AppColor.gardenGrass;

  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Tulip Garden',
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColor.leafDark,
          ),
        ),
      ),
    );
  }
}
