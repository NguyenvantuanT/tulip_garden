import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../src/resources/app_color.dart';
import 'components/garden_grid_component.dart';
import 'garden_state.dart';

class TulipGardenGame extends FlameGame {
  TulipGardenGame({GardenState? garden}) : garden = garden ?? GardenState();

  final GardenState garden;

  @override
  Color backgroundColor() => AppColor.gardenGrass;

  @override
  Future<void> onLoad() async {
    add(GardenGridComponent(garden: garden));
  }
}
