import '/kernel/drawEvent.dart';
import '/flex/object.dart';
import '/kernel/misc/Init.dart';
import '/kernel/object.dart';
import '/kernel/propagator/multi.dart';

class StackLayout extends FlexObject with MultiPropagator {
  StackLayout({required List<GraphObject> children}) {
    Init.children(this, children);
  }

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    propagate(drawEvent);
  }
}
