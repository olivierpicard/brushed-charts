import 'package:flutter/widgets.dart';
import 'drawZone.dart';

class DrawEvent {
  final Canvas canvas;
  DrawZone drawZone;

  DrawEvent(this.canvas, this.drawZone);

  DrawEvent.copy(DrawEvent event)
      : canvas = event.canvas,
        drawZone = DrawZone.copy(event.drawZone);

  DrawEvent copy() => DrawEvent.copy(this);
}
