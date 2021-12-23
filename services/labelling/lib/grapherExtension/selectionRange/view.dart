import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/geometry/geometry.dart';

class SelectionRangeView extends Geometry {
  static const double BODY_PERCENT = 0;
  SelectionRangeView({DrawUnitObject? child}) : super(BODY_PERCENT, child);

  void draw(DrawUnitEvent event) {
    super.draw(event);
    drawVerticalLine();
    // if (event.previous == null) return;
    // print(event.unitData.y);
  }

  void drawVerticalLine() {
    final drawZoneRect = baseDrawEvent!.drawZone.toRect;
    final topCenter = drawZoneRect.topCenter;
    final bottomCenter = drawZoneRect.bottomCenter;
    final paint = Paint()..color = Colors.red;
    canvas!.drawLine(topCenter, bottomCenter, paint);
  }

  @override
  DrawUnitObject instanciate() =>
      SelectionRangeView(child: child?.instanciate());
}
