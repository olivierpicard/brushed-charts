import 'package:graph_kernel/cursor.dart';
import 'package:graph_kernel/event/drawEvent.dart';
import 'package:graph_kernel/scene.dart';
import 'package:graph_kernel/sceneObject.dart';

abstract class Drawable extends SceneObject {
  Drawable(Scene scene) : super(scene) {
    eventRegistry.add(DrawEvent.id, draw);
  }

  draw(DrawEvent event);
}
