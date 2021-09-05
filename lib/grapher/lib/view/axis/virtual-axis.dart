import 'package:grapher/utils/range.dart';

import 'axis.dart';

class VirtualAxis extends Axis {
  Range virtualRange;

  VirtualAxis(Range pixelRange, double min, double max)
      : virtualRange = Range(min, max),
        super(pixelRange);

  double toPixel(double x) {
    final vMin = virtualRange.min;
    final vMax = virtualRange.max;
    final tMin = pixelRange.min;
    final tMax = pixelRange.max;
    final pixel = (x - vMin) / (vMax - vMin) * (tMax - tMin) + tMin;

    return pixel;
  }
}
