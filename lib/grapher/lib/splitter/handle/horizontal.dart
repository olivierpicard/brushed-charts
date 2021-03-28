import '/flex/object.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';

import 'base.dart';

class HorizontalHandle extends Handle {
  HorizontalHandle(FlexObject previous, FlexObject next)
      : super(previous, next);

  @override
  double getDeltaDrag(DragUpdateDetails event) => event.delta.dx;

  @override
  double getObjectLength(FlexObject object) {
    return object.baseDrawEvent!.drawZone.size.width;
  }

  @override
  List<Offset> getCircleCenters(DrawEvent drawEvent) {
    final center = getCenter(drawEvent);
    final circle2 = center;
    final circle1 = Offset(center.dx, center.dy - Handle.CIRCLE_OFFSET);
    final circle3 = Offset(center.dx, center.dy + Handle.CIRCLE_OFFSET);
    final centers = <Offset>[circle1, circle2, circle3];

    return centers;
  }
}
