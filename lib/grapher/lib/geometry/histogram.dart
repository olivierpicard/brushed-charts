import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/geometry/geometry.dart';

class Histogram extends Geometry {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 1;

  late final double bodyWidth;

  Histogram({DrawUnitObject? child}) : super(BODY_PERCENT, child);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    final bar = make(event);
    apply(bar);
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

  void apply(Rect bar) {
    Paint paint = Paint()..color = Colors.blue;
    canvas!.drawRect(bar, paint);
  }

  @override
  DrawUnitObject instanciate() => Histogram(child: child?.instanciate());
}
