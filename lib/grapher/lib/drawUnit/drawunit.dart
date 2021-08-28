import 'package:grapher/drawUnit/helper/canvas-transform.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'metadata.dart';

class DrawUnit extends GraphObject with SinglePropagator {
  final DrawUnitObject child;
  final DrawUnitMetadata metadata;

  DrawUnit(this.metadata, DrawUnitObject template)
      : child = template.instanciate() {
    Init.child(this, child);
    draw();
  }

  void draw() {
    CanvasTransform.start(this);
    final event = makeDrawUnitEvent();
    if (event != null) propagate(event);
    CanvasTransform.end(this);
  }

  DrawUnitEvent? makeDrawUnitEvent() {
    if (metadata.data == null) return null;
    return DrawUnitEvent(
        metadata.viewEvent,
        metadata.data!,
        calculateChildWidth(),
        metadata.yAxis.scale,
        this,
        metadata.previous?.child);
  }

  double calculateChildWidth() {
    final percent = child.widthPercent;
    final unitLength = metadata.viewEvent.drawZone.size.width;
    final pixelWidth = percent / 100 * unitLength;

    return pixelWidth;
  }
}
