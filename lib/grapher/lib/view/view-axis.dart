import 'package:flutter/material.dart';

class ViewAxis {
  static const double IMPOSSIBLE_VALUE = 99999999;
  final double baseUnitLength;
  double unitLength = 0;
  Offset zoom = Offset.zero;
  Offset offset = Offset.zero;
  double yMin = IMPOSSIBLE_VALUE;
  double yMax = -IMPOSSIBLE_VALUE;

  ViewAxis({required this.baseUnitLength}) {
    var _chunkLength = baseUnitLength + zoom.dx;
    if (_chunkLength <= 1) _chunkLength = 1;
    unitLength = _chunkLength;
  }
}
