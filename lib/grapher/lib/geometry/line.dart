import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/utils/misc.dart';

class Line extends Geometry {
  static const double BODY_PERCENT = 0;
  Paint paint = Paint()..color = Misc.randomColor();

  Line({Paint? paint, DrawUnitObject? child}) : super(BODY_PERCENT, child) {
    if (paint != null) this.paint = paint;
  }

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    if (event.previous == null) return;
    drawLine(event);
  }

  void drawLine(DrawUnitEvent event) {
    final prevPosition = previousPosition(event);
    final selfPosition = calculatePosition(event);
    hitZone = makeContactZone(prevPosition, selfPosition);
    canvas!.drawLine(selfPosition, prevPosition, paint);
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

  Rect? makeContactZone(Offset prev, Offset current) {
    final yDistance = (current.dy - prev.dy).abs();
    final width = baseDrawEvent!.drawZone.size.width;
    return Rect.fromCenter(
        center: current, width: width, height: yDistance * 2);
  }

  @override
  DrawUnitObject instanciate() =>
      Line(paint: paint, child: child?.instanciate());
}
