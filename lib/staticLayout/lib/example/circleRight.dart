import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/propagator/single.dart';

class CircleRight extends FlexObject with SinglePropagator {
  static const COLOR = Colors.black38;
  CircleRight({String length = "auto"}) : super(length: length);

  void draw(covariant DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = COLOR;
    final circleCenter =
        Offset(size.width / 1.5, position.dy + size.height / 2);
    canvas.drawCircle(circleCenter, size.height / 2, paint);
  }
}
