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
    final position = Offset(0, event.unitData.y);
    final color = Paint()..color = Colors.blue;
    canvas!.drawLine(position, prevPosition, color);
  }

  Offset previousPosition(DrawUnitEvent event) {
    var prevDrawZone = event.previous!.baseDrawEvent!.drawZone;
    final drawZone = baseDrawEvent!.drawZone;
    final xDistance = prevDrawZone.position.dx - drawZone.position.dx;
    final prevY = (event.previous!.baseDrawEvent! as DrawUnitEvent).unitData.y;
    final prevPosition = Offset(xDistance, prevY);

    return prevPosition;
  }

  @override
  DrawUnitObject instanciate() => Line();
}
