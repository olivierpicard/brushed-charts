import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/utils/misc.dart';

class BarChart extends Geometry {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 1;

  late final double bodyWidth;
  Paint paint = Paint()..color = Misc.randomColor();

  BarChart({Paint? paint, DrawUnitObject? child}) : super(BODY_PERCENT, child) {
    if (paint != null) this.paint = paint;
  }

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    final bar = make(event);
    hitZone = bar;
    canvas!.drawRect(bar, paint);
  }

  Rect make(DrawUnitEvent event) {
    final left = event.drawZone.toRect.left;
    final right = event.drawZone.toRect.right;
    final bottom = event.drawZone.toRect.bottom;
    final virtualTop = event.unitData.y;
    final top = event.yAxis.toPixel(virtualTop);
    final rect = Rect.fromLTRB(left, top, right, bottom);
    return rect;
  }

  @override
  DrawUnitObject instanciate() =>
      BarChart(paint: paint, child: child?.instanciate());
}
