import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tulip_garden/game/garden_layout.dart';
import 'package:tulip_garden/game/garden_state.dart';

void main() {
  const layout = GardenLayout(rows: 4, columns: 4);
  const portraitPhone = Size(390, 844);
  const wideWeb = Size(1440, 900);

  group('GardenLayout', () {
    for (final screen in const [portraitPhone, wideWeb]) {
      group('màn $screen', () {
        test('lưới căn giữa màn hình', () {
          final grid = layout.gridRect(screen);

          expect(grid.center.dx, closeTo(screen.width / 2, 0.001));
          expect(grid.center.dy, closeTo(screen.height / 2, 0.001));
        });

        test('lưới nằm trọn trong màn hình và co theo cạnh ngắn', () {
          final grid = layout.gridRect(screen);
          final margin = screen.shortestSide * layout.marginRatio;

          expect(grid.left, greaterThanOrEqualTo(0));
          expect(grid.top, greaterThanOrEqualTo(0));
          expect(grid.right, lessThanOrEqualTo(screen.width));
          expect(grid.bottom, lessThanOrEqualTo(screen.height));
          expect(
            grid.shortestSide,
            closeTo(screen.shortestSide - margin * 2, 0.001),
          );
        });

        test('mọi ô là hình vuông và không chồng lên nhau', () {
          final rects = [
            for (var row = 0; row < 4; row++)
              for (var column = 0; column < 4; column++)
                layout.plotRect(screen, GardenPosition(row, column)),
          ];

          for (final rect in rects) {
            expect(rect.width, closeTo(rect.height, 0.001));
            expect(rect.width, closeTo(layout.plotSize(screen), 0.001));
          }
          for (var a = 0; a < rects.length; a++) {
            for (var b = a + 1; b < rects.length; b++) {
              expect(rects[a].overlaps(rects[b]), isFalse);
            }
          }
        });
      });
    }

    test('lưới không vuông vẫn vừa màn hình', () {
      const wide = GardenLayout(rows: 2, columns: 6);
      final grid = wide.gridRect(portraitPhone);

      expect(grid.right, lessThanOrEqualTo(portraitPhone.width));
      expect(grid.width / grid.height, closeTo(3, 0.001));
    });

    test('màn kích thước 0 không sinh số âm', () {
      expect(layout.pitch(Size.zero), 0);
      expect(layout.plotRect(Size.zero, const GardenPosition(0, 0)).width, 0);
    });
  });
}
