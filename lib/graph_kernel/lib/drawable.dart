import 'package:graph_kernel/scene.dart';
import 'package:graph_kernel/sceneObject.dart';
import 'drawEvent.dart';

abstract class Drawable extends SceneObject {
  Drawable(Scene scene) : super(scene) {
    eventRegistry.add(DrawEvent, draw);
  }

  void draw(dynamic event);
}
