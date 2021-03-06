import 'package:kernel/object.dart';

mixin Propagator {
  final children = <GraphObject>[];

  void propagate(dynamic event) {
    for (final child in children) {
      child.handleEvent(event);
    }
  }
}
