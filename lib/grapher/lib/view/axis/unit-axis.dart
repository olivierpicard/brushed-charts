import 'package:grapher/utils/range.dart';

import 'axis.dart';

class UnitAxis extends Axis {
  // TODO: Update unitLength on zoom
  double unitLength;

  UnitAxis(Range pixelRange, this.unitLength) : super(pixelRange) {
    // print(unitLength);
  }
}
