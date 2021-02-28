import 'graphKernel.dart';
import 'package:graph_kernel/sceneObject.dart';
import 'drawEvent.dart';

abstract class Drawable extends GraphObject {
  Drawable(GraphKernel scene) : super(scene) {
    eventRegistry.add(DrawEvent, draw);
  }

  void draw(dynamic event);
}
