import 'package:grapher/drawUnit/helper/canvas-transform.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
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
    CanvasTransform.start(this);
    final outputEvent = makeDrawUnitEvent(viewEvent);
    if (outputEvent != null) propagate(outputEvent);
    CanvasTransform.end(this);
  }

  DrawUnitEvent? makeDrawUnitEvent(viewEvent) {
    if (metadata.data == null) return null;
    return DrawUnitEvent(viewEvent, metadata.data!, calculateChildWidth(),
        metadata.yAxis.scale, this, metadata.previous?.child);
  }

  double calculateChildWidth() {
    final percent = child.widthPercent;
    final unitLength = metadata.viewEvent.drawZone.size.width;
    final pixelWidth = percent / 100 * unitLength;

    return pixelWidth;
  }
}
