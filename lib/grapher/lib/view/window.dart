import 'package:flutter/gestures.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/y-virtual-range.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/boundary.dart';

class Window extends Boundary with SinglePropagator {
  static const double UNIT_DEFAULT_LENGTH = 10;
  // TODO: Window block the DrawEvent, avoid this behaviour or create a GraphView that does not comport Window module in it and let DrawEvent pass throught the chain.
  Window({unitLength = UNIT_DEFAULT_LENGTH, GraphObject? child})
      : super(unitLength: unitLength, child: child) {
    Init.child(this, child);
  }

  @override
  void draw(DrawEvent drawEvent) {
    super.draw(drawEvent);
    propagate(drawEvent);
    if (!isInputValid()) return;
    drawOnValidInput(drawEvent);
  }

  void drawOnValidInput(DrawEvent drawEvent) {
    final cuttedChain = inputData!.skip(lower).take(length);
    yAxis.virtualRange = YVirtualRangeUpdate.process(cuttedChain);
    propagate(ViewEvent(drawEvent, xAxis, yAxis, cuttedChain));
  }

  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    offsetOnZooming(event);
    super.onScroll(event);
    setState(this);
  }

  void offsetOnZooming(PointerScrollEvent event) {
    final skipCount = countSkippedChunk();
    final spreadZoom = getSpreadZoom(event.scrollDelta.dy);
    final cumuledDelta = (spreadZoom * skipCount);
    xAxis.offset -= cumuledDelta;
  }
}
