import 'package:flame/components.dart';

import '../garden_layout.dart';
import '../garden_state.dart';
import 'plot_component.dart';

class GardenGridComponent extends Component {
  GardenGridComponent({required this.garden})
    : layout = GardenLayout(rows: garden.rows, columns: garden.columns);

  final GardenState garden;
  final GardenLayout layout;

  @override
  Future<void> onLoad() async {
    for (var index = 0; index < garden.plotCount; index++) {
      add(PlotComponent(gardenPosition: garden.positionOf(index), layout: layout));
    }
  }
}
