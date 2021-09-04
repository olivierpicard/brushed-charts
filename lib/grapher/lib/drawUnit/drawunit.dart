import 'dart:ui';

import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

import 'metadata.dart';

class DrawUnit extends Viewable with SinglePropagator {
  final DrawUnitObject child;
  late final DrawUnitMetadata metadata;

  DrawUnit(this.metadata, DrawUnitObject template)
      : child = template.instanciate() {
    Init.child(this, child);
  }

  DrawUnit.template({required this.child});

  DrawUnit instanciate(DrawUnitMetadata metadata) {
    return DrawUnit(metadata, child);
  }

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final outputEvent = makeDrawUnitEvent(viewEvent);
    if (outputEvent != null) propagate(outputEvent);
  }

  DrawUnitEvent? makeDrawUnitEvent(ViewEvent viewEvent) {
    if (metadata.data == null) return null;
    final updatedViewEvent = makeUpdatedViewEvent(viewEvent);
    return DrawUnitEvent(updatedViewEvent, metadata.data!,
        calculateChildWidth(), metadata.previous?.child);
  }

  ViewEvent makeUpdatedViewEvent(ViewEvent viewEvent) {
    final drawEvent = DrawEvent.fromUpdatedDrawZone(
      viewEvent,
      makeChildDrawZone(),
    );
    final newViewEvent = ViewEvent.fromDrawEvent(
      drawEvent,
      viewEvent.viewAxis,
      viewEvent.chainData,
    );

    return newViewEvent;
  }

  double calculateChildWidth() {
    final percent = child.widthPercent;
    final unitLength = metadata.viewEvent.drawZone.size.width;
    final pixelWidth = percent / 100 * unitLength;

    return pixelWidth;
  }

  DrawZone makeChildDrawZone() {
    final childWidth = calculateChildWidth();
    final drawZone = baseDrawEvent!.drawZone;
    final startXPos = drawZone.position.dx;
    final unitYPos = drawZone.position.dy;
    final childZone = DrawZone(
      Offset(startXPos, unitYPos),
      Size(childWidth, drawZone.size.height),
    );

    return childZone;
  }
}
