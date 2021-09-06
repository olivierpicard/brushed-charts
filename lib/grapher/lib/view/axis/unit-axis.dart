import 'package:grapher/utils/range.dart';

import 'axis.dart';

class UnitAxis extends Axis {
  // TODO: Update unitLength on zoom
  late double unitLength;

  UnitAxis();

  UnitAxis.copy(UnitAxis ref)
      : unitLength = ref.unitLength,
        super.copy(ref);

  UnitAxis copy() => UnitAxis.copy(this);

  @override
  set zoom(double value) {
    final delta = zoom - value;
    super.zoom = value;
    unitLength += delta;
  }
}
