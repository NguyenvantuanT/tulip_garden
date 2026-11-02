import 'growth.dart';

class GardenPosition {
  const GardenPosition(this.row, this.column);

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      other is GardenPosition && other.row == row && other.column == column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => 'GardenPosition($row, $column)';
}

enum PlotResult { planted, occupied, harvested, empty, notReady }

class Plot {
  const Plot.empty() : plantedAt = null;

  Plot.planted(DateTime plantedAt) : plantedAt = plantedAt.toUtc();

  final DateTime? plantedAt;

  bool get isEmpty => plantedAt == null;

  GrowthStage? stageAt(DateTime now) {
    final planted = plantedAt;
    return planted == null ? null : growthStageAt(plantedAt: planted, now: now);
  }
}

class GardenState {
  GardenState({this.rows = 4, this.columns = 4})
    : assert(rows > 0 && columns > 0),
      _plots = List.filled(rows * columns, const Plot.empty());

  final int rows;
  final int columns;
  final List<Plot> _plots;

  int get plotCount => _plots.length;

  List<Plot> get plots => List.unmodifiable(_plots);

  bool contains(GardenPosition position) =>
      position.row >= 0 &&
      position.row < rows &&
      position.column >= 0 &&
      position.column < columns;

  int indexOf(GardenPosition position) {
    if (!contains(position)) {
      throw RangeError('$position is outside a ${rows}x$columns garden');
    }
    return position.row * columns + position.column;
  }

  GardenPosition positionOf(int index) {
    RangeError.checkValidIndex(index, _plots, 'index');
    return GardenPosition(index ~/ columns, index % columns);
  }

  Plot plotAt(GardenPosition position) => _plots[indexOf(position)];

  PlotResult plant(GardenPosition position, DateTime at) {
    final index = indexOf(position);
    if (!_plots[index].isEmpty) {
      return PlotResult.occupied;
    }
    _plots[index] = Plot.planted(at);
    return PlotResult.planted;
  }

  PlotResult harvest(GardenPosition position, DateTime now) {
    final index = indexOf(position);
    final stage = _plots[index].stageAt(now);
    if (stage == null) {
      return PlotResult.empty;
    }
    if (stage != GrowthStage.bloom) {
      return PlotResult.notReady;
    }
    _plots[index] = const Plot.empty();
    return PlotResult.harvested;
  }

  PlotResult tap(GardenPosition position, DateTime now) =>
      plotAt(position).isEmpty ? plant(position, now) : harvest(position, now);
}
