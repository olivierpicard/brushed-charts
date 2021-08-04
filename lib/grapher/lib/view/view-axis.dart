import 'package:flutter/material.dart';

class ViewAxis {
  final double baseChunkLength;
  late final double chunkLength;
  final Offset lengthOffset;
  final Offset offset;

  ViewAxis(
      {required this.baseChunkLength,
      this.lengthOffset = Offset.zero,
      this.offset = Offset.zero}) {
    chunkLength = baseChunkLength + lengthOffset.dx.abs();
  }

  ViewAxis setScale(Offset lenOffset) {
    return ViewAxis(
        baseChunkLength: baseChunkLength,
        lengthOffset: lenOffset,
        offset: offset);
  }

  ViewAxis setOffset(Offset offset) {
    return ViewAxis(
        baseChunkLength: baseChunkLength,
        lengthOffset: lengthOffset,
        offset: offset);
  }
}
