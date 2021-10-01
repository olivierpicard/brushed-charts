import 'package:grapher/utils/range.dart';

class Axis {
  double _zoom = 0;
  double offset = 0;
  late Range pixelRange;

  Axis();

  Axis.copy(Axis ref)
      : offset = ref.offset,
        _zoom = ref.zoom,
        pixelRange = ref.pixelRange;

  Axis copy() => Axis.copy(this);

  double get zoom => _zoom;
  void set zoom(double value) => _zoom = value;
}
