import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/tulip_garden_game.dart';

void main() {
  runApp(const TulipGardenApp());
}

class TulipGardenApp extends StatelessWidget {
  const TulipGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tulip Garden',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: GameWidget(game: TulipGardenGame())),
    );
  }
}
