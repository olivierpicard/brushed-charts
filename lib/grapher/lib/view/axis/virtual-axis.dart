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
    final pMin = pixelRange.min;
    final pMax = pixelRange.max;
    final pixel = pMax - (x - vMin) / (vMax - vMin) * (pMax - pMin);
    return pixel;
  }

  double toVirtual(double x) {
    final vMin = virtualRange.min;
    final vMax = virtualRange.max;
    final pMin = pixelRange.min;
    final pMax = pixelRange.max;
    final virtual = vMax - (x - pMin) / (pMax - pMin) * (vMax - vMin);
    return virtual;
  }
}
