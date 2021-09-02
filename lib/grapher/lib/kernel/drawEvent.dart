import 'package:flutter/widgets.dart';
import 'drawZone.dart';

class DrawEvent {
  final Canvas canvas;
  final DrawZone drawZone;

  DrawEvent(this.canvas, this.drawZone);

  DrawEvent.fromUpdatedDrawZone(DrawEvent baseEvent, DrawZone drawZone)
      : canvas = baseEvent.canvas,
        this.drawZone = drawZone;

  DrawEvent.copy(DrawEvent event)
      : canvas = event.canvas,
        drawZone = event.drawZone;
}
