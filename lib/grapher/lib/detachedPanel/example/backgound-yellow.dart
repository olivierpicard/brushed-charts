import 'package:grapher/kernel/drawable.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';
import '/kernel/propagator/single.dart';

class FillBackgroundYellow extends Drawable with SinglePropagator {
  static final COLOR = Colors.yellow.shade800;

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    final paint = Paint()..color = COLOR;
    canvas!.drawRect(drawEvent.drawZone.toRect, paint);
  }
}
