import '/flex/object.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';
import '/kernel/propagator/single.dart';

class GraphBackground extends FlexObject with SinglePropagator {
  final Color color;

  GraphBackground({required this.color, String length = "auto"})
      : super(length: length);

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = color;
    final rect = position & size;
    canvas.drawRect(rect, paint);
  }
}
