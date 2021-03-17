import 'package:kernel/sizedObject.dart';

import 'kernel.dart';
import 'object.dart';
import 'drawEvent.dart';

abstract class Drawable extends GraphObject {
  DrawEvent? baseDrawEvent;

  Drawable(GraphKernel kernel) : super(kernel) {
    eventRegistry.add(DrawEvent, draw);
  }

  void draw(dynamic drawEvent) {
    baseDrawEvent = drawEvent;
  }
}
