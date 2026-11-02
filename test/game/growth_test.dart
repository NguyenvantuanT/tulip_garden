import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/garden_state.dart';
import 'package:tulip_garden/game/growth.dart';

void main() {
  final plantedAt = DateTime.utc(2026, 2, 28, 23, 59, 30);

  GrowthStage stageAfter(Duration elapsed) =>
      growthStageAt(plantedAt: plantedAt, now: plantedAt.add(elapsed));

  group('growthStageAt', () {
    test('thời lượng mỗi giai đoạn dương, đủ cho 3 lần chuyển', () {
      expect(GrowthTiming.stageDurations.length, GrowthStage.values.length - 1);
      for (final duration in GrowthTiming.stageDurations) {
        expect(duration, greaterThan(Duration.zero));
      }
    });

    test('đúng giai đoạn ở từng mốc', () {
      expect(stageAfter(Duration.zero), GrowthStage.bulb);
      expect(stageAfter(const Duration(seconds: 10)), GrowthStage.bulb);
      expect(stageAfter(const Duration(seconds: 30)), GrowthStage.sprout);
      expect(stageAfter(const Duration(seconds: 90)), GrowthStage.bud);
      expect(stageAfter(const Duration(days: 3)), GrowthStage.bloom);
    });

    test('đúng bằng mốc thì đã sang giai đoạn sau, trước 1µs thì chưa', () {
      var threshold = Duration.zero;
      var expected = GrowthStage.bulb;
      for (final duration in GrowthTiming.stageDurations) {
        threshold += duration;
        expect(
          stageAfter(threshold - const Duration(microseconds: 1)),
          expected,
        );
        expected = GrowthStage.values[expected.index + 1];
        expect(stageAfter(threshold), expected);
      }
      expect(expected, GrowthStage.bloom);
    });

    test('thời gian lùi về trước lúc trồng vẫn là củ', () {
      expect(stageAfter(const Duration(seconds: -1)), GrowthStage.bulb);
      expect(stageAfter(const Duration(days: -400)), GrowthStage.bulb);
    });

    test('cùng một instant ở giờ địa phương cho cùng kết quả', () {
      final now = plantedAt.add(const Duration(seconds: 70));

      expect(
        growthStageAt(plantedAt: plantedAt.toLocal(), now: now),
        growthStageAt(plantedAt: plantedAt, now: now.toLocal()),
      );
      expect(
        growthStageAt(plantedAt: plantedAt.toLocal(), now: now),
        GrowthStage.bud,
      );
    });
  });

  group('Plot', () {
    test('ô trống không có giai đoạn', () {
      expect(const Plot.empty().stageAt(plantedAt), isNull);
    });

    test('lưu thời điểm trồng dạng UTC', () {
      final plot = Plot.planted(plantedAt.toLocal());

      expect(plot.isEmpty, isFalse);
      expect(plot.plantedAt?.isUtc, isTrue);
      expect(plot.plantedAt, plantedAt);
    });

    test('hỏi với clock lùi không làm hỏng state', () {
      final plot = Plot.planted(plantedAt);
      final later = plantedAt.add(const Duration(minutes: 5));

      expect(plot.stageAt(later), GrowthStage.bloom);
      expect(
        plot.stageAt(plantedAt.subtract(const Duration(hours: 1))),
        GrowthStage.bulb,
      );
      expect(plot.stageAt(later), GrowthStage.bloom);
      expect(plot.plantedAt, plantedAt);
    });
  });

  group('GardenState.plant', () {
    test('chỉ trồng đúng ô được chọn', () {
      final garden = GardenState();
      const position = GardenPosition(1, 2);

      garden.plant(position, plantedAt);

      expect(garden.plotAt(position).plantedAt, plantedAt);
      expect(garden.plots.where((plot) => !plot.isEmpty).length, 1);
    });

    test('ô đã trồng hoặc ngoài biên bị từ chối', () {
      final garden = GardenState()
        ..plant(const GardenPosition(0, 0), plantedAt);

      expect(
        () => garden.plant(const GardenPosition(0, 0), plantedAt),
        throwsStateError,
      );
      expect(
        () => garden.plant(const GardenPosition(4, 0), plantedAt),
        throwsRangeError,
      );
    });
  });
}
