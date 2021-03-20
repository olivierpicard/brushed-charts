import '../object.dart';
import 'base.dart';

mixin SinglePropagator implements Propagator {
  GraphObject? child;

  void propagate(dynamic event) => child?.handleEvent(event);
}
