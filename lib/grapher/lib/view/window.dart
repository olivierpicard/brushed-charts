import 'package:flutter/gestures.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pack/packet.dart';
import 'package:grapher/view/interactive-view.dart';
import 'package:grapher/view/view-event.dart';

class Window extends InteractiveView with SinglePropagator {
  static const double UNIT_DEFAULT_LENGTH = 10;
  late int lower, upper, length;

  Window({unitLength = UNIT_DEFAULT_LENGTH, GraphObject? child})
      : super(unitLength: unitLength, child: child) {
    Init.child(this, child);
  }

  @override
  void draw(DrawEvent drawEvent) {
    super.draw(drawEvent);
    if (!isInputValid()) return;
    final cuttedIter = truncateData();
    updateYRange(cuttedIter);
    final event = ViewEvent.fromDrawEvent(drawEvent, viewAxis, cuttedIter);
    cuttedIter.forEach((entry) {
      entry = entry as Packet;
      final tags = entry.y.map((e) => e.content);
      final min = tags.map((e) => e.yMin);
      final max = tags.map((e) => e.yMax);
      //   print(
      //       'ts: ${entry.x} -- pmin: ${entry.yMin} -- min: ${min} -- pmax: ${entry.yMax} -- max: ${max}');
    });
    // print('----------');
    print(viewAxis.yMin);
    print(viewAxis.yMax);
    // print('lower: ${cuttedIter.first.x} -- upper: ${cuttedIter.last.x}');
    propagate(event);
  }

  Iterable<Data2D> truncateData() {
    defineBoudary();
    return makeIterator();
  }

  Iterable<Data2D> makeIterator() {
    return inputData!.skip(lower).take(length);
  }

  void defineBoudary() {
    upper = getUpperBound();
    lower = getLowerBound();
    length = upper - lower;
  }

  int getUpperBound() {
    if (viewAxis.offset.dx <= 0) return inputData!.length;
    final skippedChunk = countSkippedChunk();
    final dataLen = inputData!.length;
    final upperBound = dataLen - skippedChunk;

    return upperBound;
  }

  int countSkippedChunk() {
    final xOffset = viewAxis.offset.dx;
    final chunkLen = viewAxis.chunkLength;
    final skipCounter = (xOffset / chunkLen).floor();

    return skipCounter;
  }

  int getLowerBound() {
    final upperBound = getUpperBound();
    var lowerBound = upperBound - maxDisplayableUnit();
    if (lowerBound <= 0) lowerBound = 0;

    return lowerBound;
  }

  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    super.onScroll(event);
    updateOffsetOnZoom(event);
    setState(this);
  }

  void updateOffsetOnZoom(PointerScrollEvent event) {
    final skipCount = countSkippedChunk();
    final offsetX = viewAxis.offset.dx;
    final deltaScrollX = moderatedScroll(event.scrollDelta.dy);
    var cumuledDelta = deltaScrollX * skipCount;
    cumuledDelta += deltaScrollX / 2;
    final newX = offsetX + cumuledDelta;
    final newOffset = Offset(newX, viewAxis.offset.dy);
    viewAxis = viewAxis.setOffset(newOffset);
  }

  void updateYRange(Iterable<Data2D> chain) {
    final yMin = chain
        .reduce((value, curr) => (value.yMin < curr.yMin) ? value : curr)
        .yMin;
    final yMax = chain
        .reduce((value, curr) => (value.yMax > curr.yMax) ? value : curr)
        .yMax;

    viewAxis = viewAxis.setYRange(yMin, yMax);
  }
}
