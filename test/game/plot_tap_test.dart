import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/components/coin_hud_component.dart';
import 'package:tulip_garden/game/economy.dart';
import 'package:tulip_garden/game/garden_layout.dart';
import 'package:tulip_garden/game/garden_state.dart';
import 'package:tulip_garden/game/growth.dart';
import 'package:tulip_garden/game/tulip_garden_game.dart';

void main() {
  testWidgets('chạm vào ô thì trồng rồi thu hoạch đúng ô đó', (tester) async {
    var now = DateTime.utc(2026, 3, 1, 8);
    final garden = GardenState();
    final game = TulipGardenGame(garden: garden, clock: () => now);
    const target = GardenPosition(1, 3);

    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    final screen = tester.getSize(find.byType(GameWidget<TulipGardenGame>));
    final layout = GardenLayout(rows: garden.rows, columns: garden.columns);
    final center = layout.plotRect(screen, target).center;

    final hud = game.descendants().whereType<CoinHudComponent>().single;
    expect(hud.displayedText, '0');

    await tester.tapAt(center);
    await tester.pump(kLongPressTimeout);
    expect(garden.plotAt(target).plantedAt, now);
    expect(garden.plots.where((plot) => !plot.isEmpty).length, 1);

    now = now.add(
      GrowthTiming.stageDurations.fold(Duration.zero, (a, b) => a + b),
    );
    await tester.tapAt(center);
    await tester.pump(kLongPressTimeout);
    expect(garden.plotAt(target).isEmpty, isTrue);
    expect(garden.coins, Economy.tulipPrice);
    expect(hud.displayedText, '${Economy.tulipPrice}');
  });

  testWidgets('chạm vào khoảng cỏ giữa các ô thì không trồng', (tester) async {
    final garden = GardenState();
    final game = TulipGardenGame(
      garden: garden,
      clock: () => DateTime.utc(2026, 3, 1, 8),
    );

    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    await tester.tapAt(const Offset(2, 2));
    await tester.pump(kLongPressTimeout);
    expect(garden.plots.every((plot) => plot.isEmpty), isTrue);
  });
}
