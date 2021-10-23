import 'dart:ui';

import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';

abstract class Geometry extends UnitDrawable
    with SinglePropagator, DrawUnitObject {
  final DrawUnitObject? child;
  final double widthPercent;
  late final VirtualAxis yAxis;
  late final UnitAxis xAxis;
  Rect? hitZone;

  Geometry(this.widthPercent, this.child);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    yAxis = event.yAxis;
    xAxis = event.xAxis;
  }

  bool isHit(Offset point) {
    if (hitZone == null) return false;
    return hitZone!.contains(point);
  }
}
