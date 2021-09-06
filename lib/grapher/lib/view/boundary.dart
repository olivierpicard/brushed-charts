import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/interactive-view.dart';

abstract class Boundary extends InteractiveView with SinglePropagator {
  static const double UNIT_DEFAULT_LENGTH = 10;
  late int lower, upper, length;

  Boundary({unitLength = UNIT_DEFAULT_LENGTH, GraphObject? child})
      : super(unitLength: unitLength, child: child) {
    Init.child(this, child);
  }

  void draw(DrawEvent drawEvent) {
    super.draw(drawEvent);
    if (!isInputValid()) return;
    defineBoundary();
  }

  void defineBoundary() {
    upper = getUpperBound();
    lower = getLowerBound();
    length = upper - lower;
  }

  int getUpperBound() {
    if (xAxis.offset <= 0) return inputData!.length;
    final skippedChunk = countSkippedChunk();
    final dataLen = inputData!.length;
    final upperBound = dataLen - skippedChunk;
    return upperBound;
  }

  int countSkippedChunk() {
    final xOffset = xAxis.offset;
    final unitLength = xAxis.unitLength;
    final skipCounter = (xOffset / unitLength).floor();
    return skipCounter;
  }

  int getLowerBound() {
    final upperBound = getUpperBound();
    var lowerBound = upperBound - maxDisplayableUnit();
    if (lowerBound <= 0) lowerBound = 0;
    return lowerBound;
  }
}
