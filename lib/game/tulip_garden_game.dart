import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TulipGardenGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFB8E0A0);

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
            color: Color(0xFF3B5E2B),
          ),
        ),
      ),
    );
  }
}
