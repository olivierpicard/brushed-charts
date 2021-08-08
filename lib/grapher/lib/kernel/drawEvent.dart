import 'package:flutter/widgets.dart';
import 'propagator/base.dart';
import 'drawZone.dart';

class DrawEvent {
  final Propagator parent;
  final Canvas canvas;
  final DrawZone drawZone;

  DrawEvent(this.parent, this.canvas, this.drawZone);

  DrawEvent.fromUpdatedDrawZone(DrawEvent baseEvent, DrawZone drawZone)
      : parent = baseEvent.parent,
        canvas = baseEvent.canvas,
        this.drawZone = drawZone;

  DrawEvent.copy(DrawEvent event)
      : parent = event.parent,
        canvas = event.canvas,
        drawZone = event.drawZone;
}
