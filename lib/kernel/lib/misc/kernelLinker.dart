import 'package:kernel/main.dart';
import 'package:kernel/object.dart';

class KernelLinker {
  static void child(GraphObject parent, GraphObject? child) {
    if (parent is GraphKernel) {
      if (parent.kernel == null) parent.kernel = parent;
      child?.kernel = parent;
      return;
    }
    child?.kernel = parent.kernel;
  }

  static void children(GraphObject parent, List<GraphObject> children) {
    for (final child in children) {
      KernelLinker.child(parent, child);
    }
  }
}
