import 'package:flutter/material.dart';

class ViewAxis {
  static const double IMPOSSIBLE_VALUE = 99999999;
  final double baseUnitLength;
  late final double chunkLength;
  final Offset zoom;
  final Offset offset;
  final double yMin, yMax;

  ViewAxis(
      {required this.baseUnitLength,
      this.zoom = Offset.zero,
      this.offset = Offset.zero,
      this.yMin = IMPOSSIBLE_VALUE,
      this.yMax = -IMPOSSIBLE_VALUE}) {
    var _chunkLength = baseUnitLength + zoom.dx;
    if (_chunkLength <= 1) _chunkLength = 1;
    chunkLength = _chunkLength;
  }

  ViewAxis setZoom(Offset lenOffset) {
    return ViewAxis(
        baseUnitLength: baseUnitLength,
        zoom: lenOffset,
        offset: offset,
        yMin: yMin,
        yMax: yMax);
  }

  ViewAxis setOffset(Offset offset) {
    return ViewAxis(
        baseUnitLength: baseUnitLength,
        zoom: zoom,
        offset: offset,
        yMin: yMin,
        yMax: yMax);
  }

  ViewAxis setYRange(double yMin, double yMax) {
    return ViewAxis(
        baseUnitLength: baseUnitLength,
        zoom: zoom,
        offset: offset,
        yMin: yMin,
        yMax: yMax);
  }
}
