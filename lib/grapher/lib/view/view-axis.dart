import 'package:flutter/material.dart';

class ViewAxis {
  final double baseUnitLength;
  late final double chunkLength;
  final Offset zoom;
  final Offset offset;

  ViewAxis(
      {required this.baseUnitLength,
      this.zoom = Offset.zero,
      this.offset = Offset.zero}) {
    var _chunkLength = baseUnitLength + zoom.dx;
    if (_chunkLength <= 1) _chunkLength = 1;
    chunkLength = _chunkLength;
  }

  ViewAxis setZoom(Offset lenOffset) {
    return ViewAxis(
        baseUnitLength: baseUnitLength, zoom: lenOffset, offset: offset);
  }

  ViewAxis setOffset(Offset offset) {
    return ViewAxis(baseUnitLength: baseUnitLength, zoom: zoom, offset: offset);
  }
}
