enum GrowthStage { bulb, sprout, bud, bloom }

class GrowthTiming {
  GrowthTiming._();

  static const List<Duration> stageDurations = [
    Duration(seconds: 20),
    Duration(seconds: 40),
    Duration(seconds: 60),
  ];
}

GrowthStage growthStageAt({
  required DateTime plantedAt,
  required DateTime now,
  List<Duration> stageDurations = GrowthTiming.stageDurations,
}) {
  assert(stageDurations.length == GrowthStage.values.length - 1);
  final elapsed = now.difference(plantedAt);
  var threshold = Duration.zero;
  var stage = GrowthStage.bulb;
  for (final duration in stageDurations) {
    threshold += duration;
    if (elapsed < threshold) {
      return stage;
    }
    stage = GrowthStage.values[stage.index + 1];
  }
  return stage;
}
