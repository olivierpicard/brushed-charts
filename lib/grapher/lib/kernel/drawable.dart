import 'object.dart';
import 'drawEvent.dart';

abstract class Drawable extends GraphObject {
  DrawEvent? baseDrawEvent;

  Drawable() {
    eventRegistry.add(DrawEvent, draw);
  }

  void draw(dynamic drawEvent) {
    baseDrawEvent = drawEvent;
  }
}
