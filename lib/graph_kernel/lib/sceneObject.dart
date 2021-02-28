import 'eventRegistry.dart';
import 'graphKernel.dart';

abstract class GraphObject {
  final GraphKernel scene;
  final children = <GraphObject>[];
  final eventRegistry = EventRegistry();

  GraphObject(this.scene);

  handleEvent(dynamic event) {
    final func = eventRegistry.getCallback(event.getID());
    final isEventSupported = (func != null);
    if (!isEventSupported) propagate(event);
  }

  propagate(dynamic event) {
    for (final child in children) {
      child.handleEvent(event);
    }
  }

  setState(GraphObject object) => scene.setState(object);
}
