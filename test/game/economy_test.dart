import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/economy.dart';
import 'package:tulip_garden/game/garden_state.dart';
import 'package:tulip_garden/game/growth.dart';

void main() {
  final plantedAt = DateTime.utc(2026, 3, 1, 8);
  final bloomAt = plantedAt.add(
    GrowthTiming.stageDurations.fold(Duration.zero, (a, b) => a + b),
  );
  const position = GardenPosition(0, 2);

  group('Economy.addCoins', () {
    test('cộng số nguyên chính xác', () {
      expect(Economy.addCoins(0, Economy.tulipPrice), Economy.tulipPrice);
      expect(Economy.addCoins(123456789, 10), 123456799);
    });

    test('số lớn dừng ở trần, không tràn thành âm', () {
      expect(Economy.addCoins(Economy.maxCoins - 3, 10), Economy.maxCoins);
      expect(Economy.addCoins(Economy.maxCoins, 10), Economy.maxCoins);
      expect(Economy.addCoins(Economy.maxCoins - 10, 10), Economy.maxCoins);
      expect(Economy.addCoins(Economy.maxCoins - 11, 10), Economy.maxCoins - 1);
    });
  });

  group('tiền khi thu hoạch', () {
    test('ruộng mới bắt đầu với 0 xu', () {
      expect(GardenState().coins, 0);
    });

    test('thu hoạch hoa nở cộng đúng giá mỗi lần', () {
      final garden = GardenState(coins: 5)..plant(position, plantedAt);

      garden.harvest(position, bloomAt);
      expect(garden.coins, 5 + Economy.tulipPrice);

      garden
        ..plant(position, bloomAt)
        ..harvest(position, bloomAt.add(const Duration(minutes: 5)));
      expect(garden.coins, 5 + Economy.tulipPrice * 2);
    });

    test('thu hoạch thất bại hoặc trồng thì không đổi tiền', () {
      final garden = GardenState(coins: 42);

      expect(garden.harvest(position, bloomAt), PlotResult.empty);
      expect(garden.plant(position, plantedAt), PlotResult.planted);
      expect(garden.harvest(position, plantedAt), PlotResult.notReady);
      expect(garden.plant(position, bloomAt), PlotResult.occupied);
      expect(garden.coins, 42);
    });

    test('số dư gần trần thu hoạch vẫn không vượt trần', () {
      final garden = GardenState(coins: Economy.maxCoins - 1)
        ..plant(position, plantedAt);

      expect(garden.harvest(position, bloomAt), PlotResult.harvested);
      expect(garden.coins, Economy.maxCoins);
    });
  });
}
