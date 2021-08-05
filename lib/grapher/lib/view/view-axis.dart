import 'package:flutter/material.dart';

class ViewAxis {
  final double baseChunkLength;
  late final double chunkLength;
  final Offset zoom;
  final Offset offset;

  ViewAxis(
      {required this.baseChunkLength,
      this.zoom = Offset.zero,
      this.offset = Offset.zero}) {
    var _chunkLength = baseChunkLength + zoom.dx;
    if (_chunkLength <= 1) _chunkLength = 1;
    chunkLength = _chunkLength;
  }

  ViewAxis setScale(Offset lenOffset) {
    return ViewAxis(
        baseChunkLength: baseChunkLength, zoom: lenOffset, offset: offset);
  }

  ViewAxis setOffset(Offset offset) {
    return ViewAxis(
        baseChunkLength: baseChunkLength, zoom: zoom, offset: offset);
  }
}
