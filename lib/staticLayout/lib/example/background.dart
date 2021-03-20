import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';
import 'package:kernel/singlePropagator.dart';

class GraphBackground extends FlexObject with SinglePropagator {
  final Color color;
  GraphBackground({required this.color, String length = "auto"})
      : super(length: length);

  void draw(covariant DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = color;
    final rect = position & size;
    canvas.drawRect(rect, paint);
  }
}
