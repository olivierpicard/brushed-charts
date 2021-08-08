import 'package:grapher/drawUnit/instanciable.dart';
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
    final canvas = metadata.viewEvent.canvas;
    final unitPosition = metadata.viewEvent.drawZone.position;
    final double scaleFactor = metadata.yAxis.scale;

    final minY = metadata.yAxis.min * scaleFactor;
    canvas.save();
    canvas.translate(unitPosition.dx,
        unitPosition.dy + minY + metadata.viewEvent.drawZone.size.height);
    canvas.translate(childXCenter(), 0);
    canvas.scale(1, -scaleFactor);
    final event = makeEvent();
    propagate(event);
    canvas.restore();
  }

  double childXCenter() {
    final childWidth = calculateChildWidth();
    final unitCenter = metadata.viewEvent.drawZone.size.width / 2;
    final startPosition = unitCenter - childWidth / 2;

    return startPosition;
  }

  double calculateChildWidth() {
    final percent = child.widthPercent;
    final unitLength = metadata.viewEvent.drawZone.size.width;
    final pixelWidth = percent / 100 * unitLength;

    return pixelWidth;
  }

  DrawUnitEvent makeEvent() {
    return DrawUnitEvent(
        metadata.viewEvent,
        metadata.data,
        calculateChildWidth(),
        metadata.yAxis.scale,
        this,
        metadata.previous?.child);
  }
}
