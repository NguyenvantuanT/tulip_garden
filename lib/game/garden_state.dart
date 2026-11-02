import 'economy.dart';
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

enum PurchaseResult { purchased, notEnoughCoins, maxSize, nothingToFertilize }

class Plot {
  const Plot.empty() : plantedAt = null;

  Plot.planted(DateTime plantedAt) : plantedAt = plantedAt.toUtc();

  final DateTime? plantedAt;

  bool get isEmpty => plantedAt == null;

  Plot fertilized(DateTime now) {
    final planted = plantedAt;
    if (planted == null) {
      return this;
    }
    final elapsed = now.difference(planted);
    final remaining =
        GrowthTiming.totalDuration -
        (elapsed.isNegative ? Duration.zero : elapsed);
    if (remaining <= Duration.zero) {
      return this;
    }
    return Plot.planted(planted.subtract(remaining ~/ 2));
  }

  GrowthStage? stageAt(DateTime now) {
    final planted = plantedAt;
    return planted == null ? null : growthStageAt(plantedAt: planted, now: now);
  }
}

class GardenState {
  GardenState({this.rows = 4, this.columns = 4, int coins = 0})
    : assert(rows > 0 && columns > 0),
      assert(rows <= maxSide && columns <= maxSide),
      assert(coins >= 0 && coins <= Economy.maxCoins),
      _plots = List.filled(rows * columns, const Plot.empty()),
      _coins = coins;

  static const int maxSide = 6;

  int rows;
  int columns;
  List<Plot> _plots;
  int _coins;

  int get coins => _coins;

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
    _coins = Economy.addCoins(_coins, Economy.tulipPrice);
    return PlotResult.harvested;
  }

  PlotResult tap(GardenPosition position, DateTime now) =>
      plotAt(position).isEmpty ? plant(position, now) : harvest(position, now);

  bool get isMaxSize => rows >= maxSide && columns >= maxSide;

  int get expandPrice => Economy.expandPrice(plotCount);

  PurchaseResult expand() {
    if (isMaxSize) {
      return PurchaseResult.maxSize;
    }
    final price = expandPrice;
    if (_coins < price) {
      return PurchaseResult.notEnoughCoins;
    }
    final newRows = columns > rows ? rows + 1 : rows;
    final newColumns = columns > rows ? columns : columns + 1;
    final grown = List<Plot>.filled(newRows * newColumns, const Plot.empty());
    for (var index = 0; index < _plots.length; index++) {
      final position = positionOf(index);
      grown[position.row * newColumns + position.column] = _plots[index];
    }
    _plots = grown;
    rows = newRows;
    columns = newColumns;
    _coins -= price;
    return PurchaseResult.purchased;
  }

  PurchaseResult fertilize(DateTime now) {
    final growing = [
      for (var index = 0; index < _plots.length; index++)
        if (_isGrowing(_plots[index], now)) index,
    ];
    if (growing.isEmpty) {
      return PurchaseResult.nothingToFertilize;
    }
    if (_coins < Economy.fertilizerPrice) {
      return PurchaseResult.notEnoughCoins;
    }
    for (final index in growing) {
      _plots[index] = _plots[index].fertilized(now);
    }
    _coins -= Economy.fertilizerPrice;
    return PurchaseResult.purchased;
  }

  bool _isGrowing(Plot plot, DateTime now) {
    final stage = plot.stageAt(now);
    return stage != null && stage != GrowthStage.bloom;
  }
}
