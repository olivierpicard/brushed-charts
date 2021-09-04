import 'package:flutter/gestures.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/boundary.dart';

class Window extends Boundary with SinglePropagator {
  static const double UNIT_DEFAULT_LENGTH = 10;

  Window({unitLength = UNIT_DEFAULT_LENGTH, GraphObject? child})
      : super(unitLength: unitLength, child: child) {
    Init.child(this, child);
  }

  @override
  void draw(DrawEvent drawEvent) {
    super.draw(drawEvent);
    if (!isInputValid()) return;
    drawOnValidInput(drawEvent);
  }

  void drawOnValidInput(DrawEvent drawEvent) {
    final cuttedChain = inputData!.skip(lower).take(length);
    updateYRange(cuttedChain);
    propagate(ViewEvent.fromDrawEvent(
      drawEvent,
      viewAxis,
      cuttedChain,
    ));
  }

  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    super.onScroll(event);
    shiftOnZooming(event);
    setState(this);
  }

  void shiftOnZooming(PointerScrollEvent event) {
    final skipCount = countSkippedChunk();
    final offsetX = viewAxis.offset.dx;
    final deltaScrollX = moderatedScroll(event.scrollDelta.dy);
    var cumuledDelta = deltaScrollX * skipCount;
    cumuledDelta += deltaScrollX / 2;
    final newX = offsetX + cumuledDelta;
    final newOffset = Offset(newX, viewAxis.offset.dy);
    viewAxis.offset = newOffset;
  }

  void updateYRange(Iterable<Data2D> chain) {
    viewAxis.yMin = chain.reduce((value, curr) {
      return (value.yMin < curr.yMin) ? value : curr;
    }).yMin;

    viewAxis.yMax = chain.reduce((value, curr) {
      return (value.yMax > curr.yMax) ? value : curr;
    }).yMax;
  }
}
