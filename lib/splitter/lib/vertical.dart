import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:kernel/drawEvent.dart';
import 'package:flex/object.dart';
import 'package:kernel/drawZone.dart';
import 'package:kernel/misc/Init.dart';
import 'package:kernel/propagator/multi.dart';
import 'package:splitter/handle.dart';

class VerticalSplitter extends FlexObject with MultiPropagator {
  late double rawLength;

  VerticalSplitter({required List<FlexObject> children}) {
    Init.children(this, children);

    addHandles();
  }

  void addHandles() {
    for (int i = 1; i < children.length; i += 2) {
      final previous = children[i - 1] as FlexObject;
      final current = children[i] as FlexObject;
      final handle = HandleSplitter(previous, current);
      children.insert(i, handle);
    }
  }

  void draw(covariant DrawEvent drawEvent) {
    final children = this.children as List<FlexObject>;
    super.draw(drawEvent);
    updateRawLength();
    DrawEvent? lastEvent;
    for (final child in children) {
      lastEvent = makeDrawEvent(lastEvent, child);
      child.handleEvent(lastEvent);
    }
  }

  void updateRawLength() {
    final baseHeight = baseDrawEvent!.drawZone.size.height;
    final viewCount = getViewCount();
    if (children.length <= 1) {
      rawLength = baseHeight;
      return;
    }
    rawLength = baseHeight / viewCount;
  }

  int getViewCount() {
    final childrenCount = children.length;
    final handleCount = (childrenCount / 2).truncate();
    final viewCount = childrenCount - handleCount;

    return viewCount;
  }

  DrawEvent makeDrawEvent(DrawEvent? lastDrawEvent, FlexObject child) {
    final zone = makeDrawZone(lastDrawEvent, child);
    final event = DrawEvent(this, baseDrawEvent!.canvas, zone);

    return event;
  }

  DrawZone makeDrawZone(DrawEvent? lastDrawEvent, FlexObject child) {
    final position = makeZonePosition(lastDrawEvent);
    final length = getChildLength(child);
    final size = defineObjectSize(length);
    final zone = DrawZone(position, size);

    return zone;
  }

  Offset makeZonePosition(DrawEvent? lastEvent) {
    final x = baseDrawEvent!.drawZone.position.dx;
    final y = lastEvent?.drawZone.endPosition().dy ??
        baseDrawEvent!.drawZone.position.dy;

    return Offset(x, y);
  }

  Size defineObjectSize(double length) {
    final objectSize = Size(baseDrawEvent!.drawZone.size.width, length);
    return objectSize;
  }

  double getChildLength(FlexObject child) {
    if (child is HandleSplitter) return HandleSplitter.THICKNESS;
    if (child == children.first) return rawLength;
    final netLength = rawLength - HandleSplitter.THICKNESS;
    final biasedLength = netLength + child.length.bias;

    return biasedLength;
  }
}
