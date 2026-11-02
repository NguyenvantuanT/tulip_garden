import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../src/resources/app_color.dart';
import 'clock.dart';
import 'components/garden_grid_component.dart';
import 'garden_state.dart';

class TulipGardenGame extends FlameGame {
  TulipGardenGame({GardenState? garden, Clock? clock})
    : garden = garden ?? GardenState(),
      clock = clock ?? systemClock;

  final GardenState garden;
  final Clock clock;

  @override
  Color backgroundColor() => AppColor.gardenGrass;

  @override
  Future<void> onLoad() async {
    add(GardenGridComponent(garden: garden, clock: clock));
  }
}
