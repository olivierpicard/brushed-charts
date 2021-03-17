import 'package:kernel/drawEvent.dart';
import 'package:kernel/kernel.dart';
import 'package:staticLayout/verticalLayout.dart';

class VAlign extends VerticalLayout {
  VAlign(GraphKernel kernel) : super(kernel);

  @override
  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    DrawEvent? lastDrawEvent;
    for (final child in children) {
      lastDrawEvent = makeDrawEvent(lastDrawEvent, child);
      child.propagate(drawEvent);
    }
  }
}
