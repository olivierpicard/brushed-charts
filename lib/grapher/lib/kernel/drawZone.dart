import 'dart:ui';

import 'package:grapher/utils/range.dart';

class DrawZone {
  Offset position;
  Size size;

  DrawZone.copy(DrawZone ref)
      : position = ref.position,
        size = ref.size;

  DrawZone(this.position, this.size);

  DrawZone copy() => DrawZone.copy(this);

  Offset endPosition() => toRect.bottomRight;
  Rect get toRect => position & size;
  Range get yRange => Range(toRect.top, toRect.bottom);
  Range get xRange => Range(toRect.left, toRect.right);
}
