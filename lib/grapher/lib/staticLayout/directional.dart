import '/flex/resolver.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';
import '/kernel/drawZone.dart';
import '/flex/object.dart';
import '/kernel/misc/Init.dart';
import '/kernel/propagator/multi.dart';

abstract class DirectionalLayout extends FlexObject with MultiPropagator {
  late FlexResolver resolver;

  DirectionalLayout(List<FlexObject> children) {
    Init.children(this, children);
  }

  Offset makeZonePosition(DrawEvent? lastEvent);
  Size defineObjectSize(double length);

  void draw(covariant DrawEvent drawEvent) {
    final children = this.children as List<FlexObject>;
    super.draw(drawEvent);
    DrawEvent? lastEvent;
    for (final child in children) {
      lastEvent = makeDrawEvent(lastEvent, child);
      child.handleEvent(lastEvent);
    }
  }

  DrawEvent makeDrawEvent(DrawEvent? lastDrawEvent, FlexObject child) {
    final zone = makeDrawZone(lastDrawEvent, child);
    final event = DrawEvent(baseDrawEvent!.canvas, zone);

    return event;
  }

  DrawZone makeDrawZone(DrawEvent? lastDrawEvent, FlexObject child) {
    final position = makeZonePosition(lastDrawEvent);
    final length = getChildLength(child);
    final size = defineObjectSize(length);
    final zone = DrawZone(position, size);

    return zone;
  }

  double getChildLength(FlexObject child) => resolver.getLength(child);
}
