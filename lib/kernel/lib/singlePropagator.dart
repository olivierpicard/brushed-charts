import 'object.dart';
import 'propagator.dart';

mixin SinglePropagator implements Propagator {
  GraphObject? child;

  void propagate(dynamic event) => child?.handleEvent(event);
}
