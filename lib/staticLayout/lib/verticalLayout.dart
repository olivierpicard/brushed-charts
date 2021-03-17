import 'dart:ui';

import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';
import 'directionallayout.dart';
import 'util/vSizeResolver.dart';

abstract class VerticalLayout extends DirectionalLayout {
  VerticalLayout(GraphKernel kernel) : super(kernel);

  @override
  void draw(covariant DrawEvent drawEvent) {
    sizeResolver = VSizeResolver(children, drawEvent.drawZone.size);
    DrawEvent? lastEvent;
    for (final child in children) {
      lastEvent = makeDrawEvent(lastEvent, child);
      child.propagate(lastEvent);
    }
  }

  Offset makeZonePosition(DrawEvent? lastEvent) {
    final x = baseDrawEvent!.drawZone.position.dx;
    final y = lastEvent?.drawZone.endPosition().dy ??
        baseDrawEvent!.drawZone.position.dy;

    return Offset(x, y);
  }
}
