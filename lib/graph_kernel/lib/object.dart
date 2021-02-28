import 'eventRegistry.dart';
import 'kernel.dart';

abstract class GraphObject {
  final GraphKernel kernel;
  final children = <GraphObject>[];
  final eventRegistry = EventRegistry();

  GraphObject(this.kernel);

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

  setState(GraphObject object) => kernel.setState(object);
}
