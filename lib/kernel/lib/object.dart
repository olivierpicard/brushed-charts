import 'propagator.dart';
import 'eventRegistry.dart';
import 'kernel.dart';

abstract class GraphObject with Propagator {
  final GraphKernel kernel;
  final eventRegistry = EventRegistry();

  GraphObject(this.kernel);

  void handleEvent(dynamic event) {
    final func = eventRegistry.getCallback(event.getID());
    final isEventSupported = (func != null);
    if (!isEventSupported) propagate(event);
  }

  void setState(GraphObject object) => kernel.setState(object);
}
