import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class Line extends Geometry with EndlinePropagator {
  static const double BODY_PERCENT = 0;

  Line() : super(BODY_PERCENT);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    if (event.previous == null) return;
    drawLine(event);
  }

  void drawLine(DrawUnitEvent event) {
    final prevPosition = previousPosition(event);
    final selfPosition = calculatePosition(event);
    final color = Paint()..color = Colors.blue;
    canvas!.drawLine(selfPosition, prevPosition, color);
  }

  Offset calculatePosition(DrawUnitEvent event) {
    final yValue = event.unitData.y;
    final yPosition = event.yAxis.toPixel(yValue);
    final xPosition = event.drawZone.toRect.center.dx;
    final position = Offset(xPosition, yPosition);
    return position;
  }

  Offset previousPosition(DrawUnitEvent event) {
    final xCenter = event.previous!.baseDrawEvent!.drawZone.toRect.center.dx;
    final yValue = (event.previous!.baseDrawEvent! as DrawUnitEvent).unitData.y;
    final yPixel = event.yAxis.toPixel(yValue);
    final prevPosition = Offset(xCenter, yPixel);

    return prevPosition;
  }

  @override
  DrawUnitObject instanciate() => Line();
}
