import 'dart:ui';

import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/metadata.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';

import '../drawunit.dart';

class ChildDrawZone {
  static DrawZone make(DrawUnit unit) {
    final child = unit.child;
    final metadata = unit.metadata;
    final baseEvent = unit.baseDrawEvent!;
    final width = childWidth(child, metadata);
    final drawZone = childDrawZone(width, baseEvent);

    return drawZone;
  }

  static double childWidth(DrawUnitObject child, DrawUnitMetadata metadata) {
    final percent = child.widthPercent;
    final drawZone = metadata.viewEvent.drawZone;
    final unitLength = drawZone.size.width;
    final pixelWidth = percent / 100 * unitLength;

    return pixelWidth;
  }

  static DrawZone childDrawZone(double childWidth, DrawEvent event) {
    final drawZone = event.drawZone;
    final startXPos = drawZone.position.dx;
    final unitYPos = drawZone.position.dy;
    final childZone = DrawZone(
      Offset(startXPos, unitYPos),
      Size(childWidth, drawZone.size.height),
    );

    return childZone;
  }
}
