import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';

class GraphBackground extends FlexObject {
  final Color color;
  GraphBackground(GraphKernel kernel, this.color) : super(kernel);

  void draw(covariant DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = color;
    final rect = position & size;
    canvas.drawRect(rect, paint);
  }
}
