import 'package:flex/resolver.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/drawZone.dart';
import 'package:kernel/kernel.dart';
import 'package:flex/object.dart';

abstract class DirectionalLayout extends FlexObject {
  final List<FlexObject> children = <FlexObject>[];
  late FlexResolver resolver;

  DirectionalLayout(GraphKernel kernel) : super(kernel);

  Offset makeZonePosition(DrawEvent? lastEvent);
  Size defineObjectSize(double length);

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    DrawEvent? lastEvent;
    for (final child in children) {
      lastEvent = makeDrawEvent(lastEvent, child);
      child.handleEvent(lastEvent);
    }
  }

  DrawEvent makeDrawEvent(DrawEvent? lastDrawEvent, FlexObject child) {
    final zone = makeDrawZone(lastDrawEvent, child);
    final event = DrawEvent(this, baseDrawEvent!.canvas, zone);

    return event;
  }

  DrawZone makeDrawZone(DrawEvent? lastDrawEvent, FlexObject child) {
    final position = makeZonePosition(lastDrawEvent);
    final length = resolver.getLength(child);
    final size = defineObjectSize(length);
    final zone = DrawZone(position, size);

    return zone;
  }
}
