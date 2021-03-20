import 'propagator.dart';
import 'eventRegistry.dart';
import 'kernel.dart';

abstract class GraphObject with Propagator {
  final GraphKernel kernel;
  final eventRegistry = EventRegistry();

  GraphObject(this.kernel);

  void handleEvent(dynamic event) {
    final callback = eventRegistry.getCallback(event.runtimeType);
    final isEventSupported = (callback != null);
    if (!isEventSupported)
      propagate(event);
    else
      callback!(event);
  }

  void setState(GraphObject object) => kernel.setState(object);
}
