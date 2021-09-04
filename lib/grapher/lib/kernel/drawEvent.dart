import 'package:flutter/widgets.dart';
import 'drawZone.dart';

class DrawEvent {
  final Canvas canvas;
  DrawZone drawZone;

  DrawEvent(this.canvas, this.drawZone);

  //TODO: Remove this function later
  DrawEvent.fromUpdatedDrawZone(DrawEvent baseEvent, DrawZone drawZone)
      : canvas = baseEvent.canvas,
        this.drawZone = drawZone;

  DrawEvent.copy(DrawEvent event)
      : canvas = event.canvas,
        drawZone = DrawZone.copy(event.drawZone);

  DrawEvent copy() => DrawEvent.copy(this);
}
