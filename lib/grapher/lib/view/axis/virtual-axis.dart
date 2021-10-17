import 'package:grapher/utils/range.dart';

import 'axis.dart';

class VirtualAxis extends Axis {
  late Range virtualRange;

  VirtualAxis();

  VirtualAxis.copy(VirtualAxis ref)
      : virtualRange = ref.virtualRange,
        super.copy(ref);

  VirtualAxis copy() => VirtualAxis.copy(this);

  double toPixel(double x) {
    final vMin = virtualRange.min;
    final vMax = virtualRange.max;
    final tMin = pixelRange.min;
    final tMax = pixelRange.max;
    final pixel = tMax - (x - vMin) / (vMax - vMin) * (tMax - tMin);
    return pixel;
  }
}
