import 'axis.dart';

class UnitAxis extends Axis {
  late double unitLength;

  UnitAxis();

  UnitAxis.copy(UnitAxis ref)
      : unitLength = ref.unitLength,
        super.copy(ref);

  UnitAxis copy() => UnitAxis.copy(this);

  @override
  set zoom(double value) {
    final delta = zoom - value;
    unitLength += delta;
    super.zoom = value;
  }
}
