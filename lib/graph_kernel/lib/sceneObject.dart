import 'event/sceneEvent.dart';
import 'eventRegistry.dart';
import 'scene.dart';

abstract class SceneObject {
  final Scene scene;
  final children = <SceneObject>[];
  final eventRegistry = EventRegistry();

  SceneObject(this.scene);

  handleEvent(SceneEvent event) {
    final func = eventRegistry.getCallback(event.getID());
    final isEventSupported = (func != null);
    if (!isEventSupported) propagate(event);
  }

  propagate(SceneEvent event) {
    for (final child in children) {
      child.handleEvent(event);
    }
  }

  setState(SceneObject object) => scene.setState(object);
}
