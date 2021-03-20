import 'object.dart';
import 'propagator.dart';

mixin MultiPropagator implements Propagator {
  late List<GraphObject> children;

  void propagate(dynamic event) {
    for (final child in children) {
      child.handleEvent(event);
    }
  }
}
