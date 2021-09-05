import 'package:grapher/utils/range.dart';

class Axis {
  // TODO: use a set property to make some change on zoom change
  double zoom = 0;
  double offset = 0;
  Range pixelRange;

  Axis(this.pixelRange);
}
