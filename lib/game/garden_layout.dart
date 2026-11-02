import 'dart:math' as math;
import 'dart:ui';

import 'garden_state.dart';

class GardenLayout {
  const GardenLayout({
    required this.rows,
    required this.columns,
    this.marginRatio = 0.08,
    this.gapRatio = 0.08,
    this.reservedBottom = 0,
  });

  final int rows;
  final int columns;
  final double marginRatio;
  final double gapRatio;
  final double reservedBottom;

  double pitch(Size screen) {
    final margin = screen.shortestSide * marginRatio;
    final availableWidth = math.max(0.0, screen.width - margin * 2);
    final availableHeight = math.max(
      0.0,
      screen.height - reservedBottom - margin * 2,
    );
    return math.min(availableWidth / columns, availableHeight / rows);
  }

  double plotSize(Size screen) => pitch(screen) * (1 - gapRatio);

  Rect gridRect(Size screen) {
    final cell = pitch(screen);
    return Rect.fromCenter(
      center: Offset(
        screen.width / 2,
        math.max(0.0, screen.height - reservedBottom) / 2,
      ),
      width: cell * columns,
      height: cell * rows,
    );
  }

  Rect plotRect(Size screen, GardenPosition position) {
    final cell = pitch(screen);
    final gap = cell * gapRatio;
    final grid = gridRect(screen);
    return Rect.fromLTWH(
      grid.left + position.column * cell + gap / 2,
      grid.top + position.row * cell + gap / 2,
      cell - gap,
      cell - gap,
    );
  }
}
