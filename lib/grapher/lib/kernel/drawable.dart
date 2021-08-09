import 'dart:ui';

import 'object.dart';
import 'drawEvent.dart';

abstract class Drawable extends GraphObject {
  DrawEvent? baseDrawEvent;
  Canvas? canvas;

  Drawable() {
    eventRegistry.add(DrawEvent, (e) => draw(e as DrawEvent));
  }

  void draw(DrawEvent drawEvent) {
    baseDrawEvent = drawEvent;
    canvas = drawEvent.canvas;
  }
}
