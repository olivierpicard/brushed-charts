import 'package:flutter/material.dart';

class ViewAxis {
  static const double IMPOSSIBLE_VALUE = 99999999;
  static const double MIN_UNIT_LENGTH = 1.5;
  static const double MAX_UNIT_LENGTH = 90;
  final double baseUnitLength;
  double unitLength = 1;
  Offset _zoom = Offset.zero;
  Offset offset = Offset.zero;
  double yMin = IMPOSSIBLE_VALUE;
  double yMax = -IMPOSSIBLE_VALUE;

  ViewAxis({required this.baseUnitLength}) : unitLength = baseUnitLength;

  ViewAxis.copy(ViewAxis axis)
      : baseUnitLength = axis.baseUnitLength,
        unitLength = axis.unitLength,
        _zoom = axis.zoom,
        offset = axis.offset,
        yMin = axis.yMin,
        yMax = axis.yMax;

  Offset get zoom => _zoom;

  set zoom(Offset newZoom) {
    var newUnitLength = baseUnitLength + newZoom.dx;
    if (newUnitLength <= MIN_UNIT_LENGTH) return;
    if (newUnitLength >= MAX_UNIT_LENGTH) return;
    unitLength = newUnitLength;
    _zoom = newZoom;
  }

  ViewAxis copy() => ViewAxis.copy(this);
}
