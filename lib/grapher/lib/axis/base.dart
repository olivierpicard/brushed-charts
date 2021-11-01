import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grapher/flex/object.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

abstract class AxisObject extends Drawable with SinglePropagator {
  final GraphObject? child;
  AxisObject(this.child);

  @override
  void draw(DrawEvent event) {
    super.draw(event);
    drawBackground(event);
  }

  void drawBackground(DrawEvent event) {
    final zone = event.drawZone.toRect;
    final paint = Paint()..color = Colors.black;
    canvas!.drawRect(zone, paint);
  }
}
