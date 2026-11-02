import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/garden_state.dart';
import 'package:tulip_garden/game/growth.dart';

void main() {
  group('GardenState', () {
    test('mặc định là lưới 4x4 với 16 ô', () {
      final garden = GardenState();

      expect(garden.rows, 4);
      expect(garden.columns, 4);
      expect(garden.plotCount, 16);
    });

    test('mọi ô ban đầu đều trống', () {
      final garden = GardenState(rows: 3, columns: 5);

      expect(garden.plots.every((plot) => plot.isEmpty), isTrue);
    });

    test('index và toạ độ đổi qua lại khớp nhau trên lưới không vuông', () {
      final garden = GardenState(rows: 3, columns: 5);

      for (var index = 0; index < garden.plotCount; index++) {
        expect(garden.indexOf(garden.positionOf(index)), index);
      }
      expect(garden.indexOf(const GardenPosition(1, 0)), 5);
      expect(garden.positionOf(14), const GardenPosition(2, 4));
    });

    test('toạ độ ngoài biên bị từ chối', () {
      final garden = GardenState();

      for (final position in const [
        GardenPosition(-1, 0),
        GardenPosition(0, -1),
        GardenPosition(4, 0),
        GardenPosition(0, 4),
      ]) {
        expect(garden.contains(position), isFalse);
        expect(() => garden.indexOf(position), throwsRangeError);
        expect(() => garden.plotAt(position), throwsRangeError);
      }
    });

    test('index ngoài biên bị từ chối', () {
      final garden = GardenState();

      expect(() => garden.positionOf(-1), throwsRangeError);
      expect(() => garden.positionOf(16), throwsRangeError);
    });

    test('danh sách ô không sửa được từ bên ngoài', () {
      final garden = GardenState();

      expect(
        () => garden.plots.add(const Plot.empty()),
        throwsUnsupportedError,
      );
    });
  });

  group('trồng và thu hoạch', () {
    final plantedAt = DateTime.utc(2026, 3, 1, 8);
    final bloomAt = plantedAt.add(
      GrowthTiming.stageDurations.fold(Duration.zero, (a, b) => a + b),
    );
    const position = GardenPosition(2, 1);

    test('trồng ô trống thì ô có củ, các ô khác vẫn trống', () {
      final garden = GardenState();

      expect(garden.plant(position, plantedAt), PlotResult.planted);
      expect(garden.plotAt(position).plantedAt, plantedAt);
      expect(garden.plots.where((plot) => !plot.isEmpty).length, 1);
    });

    test('trồng ô đã có thì báo occupied, giữ nguyên thời điểm trồng cũ', () {
      final garden = GardenState()..plant(position, plantedAt);

      expect(garden.plant(position, bloomAt), PlotResult.occupied);
      expect(garden.plotAt(position).plantedAt, plantedAt);
    });

    test('thu hoạch ô trống thì báo empty', () {
      final garden = GardenState();

      expect(garden.harvest(position, bloomAt), PlotResult.empty);
      expect(garden.plotAt(position).isEmpty, isTrue);
    });

    test('thu hoạch khi chưa nở thì báo notReady, hoa vẫn còn', () {
      final garden = GardenState()..plant(position, plantedAt);
      final justBefore = bloomAt.subtract(const Duration(microseconds: 1));

      expect(garden.harvest(position, justBefore), PlotResult.notReady);
      expect(garden.plotAt(position).plantedAt, plantedAt);
    });

    test('thu hoạch hoa đã nở thì ô trở lại trống', () {
      final garden = GardenState()..plant(position, plantedAt);

      expect(garden.harvest(position, bloomAt), PlotResult.harvested);
      expect(garden.plotAt(position).isEmpty, isTrue);
    });

    test('chạm: ô trống thì trồng, hoa nở thì thu hoạch, chưa nở thì giữ', () {
      final garden = GardenState();

      expect(garden.tap(position, plantedAt), PlotResult.planted);
      expect(garden.tap(position, plantedAt), PlotResult.notReady);
      expect(garden.tap(position, bloomAt), PlotResult.harvested);
      expect(garden.plotAt(position).isEmpty, isTrue);
    });

    test('ô ngoài biên vẫn là lỗi lập trình', () {
      final garden = GardenState();
      const outside = GardenPosition(4, 0);

      expect(() => garden.plant(outside, plantedAt), throwsRangeError);
      expect(() => garden.harvest(outside, bloomAt), throwsRangeError);
    });
  });
}
