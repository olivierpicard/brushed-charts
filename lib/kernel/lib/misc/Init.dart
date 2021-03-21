import '../propagator/single.dart';
import '../propagator/multi.dart';

import '../object.dart';

class Init {
  static void child(GraphObject parent, GraphObject? child) {
    (parent as SinglePropagator).child = child;
  }

  static void children(GraphObject parent, List<GraphObject> children) {
    (parent as MultiPropagator).children = children;
  }
}
