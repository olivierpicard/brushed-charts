import '/flex/object.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';

import 'base.dart';

class VerticalHandle extends Handle {
  VerticalHandle(FlexObject previous, FlexObject next) : super(previous, next);

  @override
  double getDeltaDrag(DragUpdateDetails event) => event.delta.dy;

  @override
  double getObjectLength(FlexObject object) {
    return object.baseDrawEvent!.drawZone.size.height;
  }

  @override
  List<Offset> getCircleCenters(DrawEvent drawEvent) {
    final center = getCenter(drawEvent);
    final circle2 = center;
    final circle1 = Offset(center.dx - Handle.CIRCLE_OFFSET, center.dy);
    final circle3 = Offset(center.dx + Handle.CIRCLE_OFFSET, center.dy);
    final centers = <Offset>[circle1, circle2, circle3];

    return centers;
  }
}
