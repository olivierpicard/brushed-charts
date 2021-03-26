import 'package:kernel/linkEvent.dart';

import 'propagator/base.dart';

import 'eventRegistry.dart';
import 'kernel.dart';

abstract class GraphObject implements Propagator {
  GraphKernel? kernel;
  GraphKernel? root;

  final eventRegistry = EventRegistry();

  void handleEvent(dynamic event) {
    listenSpecialEvent(event);
    final callback = eventRegistry.getCallback(event.runtimeType);
    final isEventSupported = (callback != null);
    if (!isEventSupported)
      propagate(event);
    else
      callback!(event);
  }

  void listenSpecialEvent(dynamic event) {
    if (event is KernelLinkEvent) {
      kernel = event.kernel;
    }
  }

  void setState(GraphObject object) => kernel!.setState(object);
}
