import 'package:grapher/kernel/abstractKernel.dart';

import 'linkEvent.dart';
import 'propagator/base.dart';
import 'eventRegistry.dart';

abstract class GraphObject implements Propagator {
  AbstractKernel? kernel;
  AbstractKernel? root;

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
      onKernelLinkEvent(event);
    }
  }

  void onKernelLinkEvent(KernelLinkEvent event) {
    kernel = event.kernel;
  }

  void setState(GraphObject object) => kernel?.setState(object);
}
