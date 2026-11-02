import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/garden_state.dart';

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

      expect(() => garden.plots.add(const Plot.empty()), throwsUnsupportedError);
    });
  });
}
