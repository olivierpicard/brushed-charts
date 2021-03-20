import '../singlePropagator.dart';
import '../multiPropagator.dart';
import '../object.dart';
import 'kernelLinker.dart';

class Init {
  static void child(GraphObject parent, GraphObject? child) {
    KernelLinker.child(parent, child);
    (parent as SinglePropagator).child = child;
  }

  static void children(GraphObject parent, List<GraphObject> children) {
    KernelLinker.children(parent, children);
    (parent as MultiPropagator).children = children;
  }
}
