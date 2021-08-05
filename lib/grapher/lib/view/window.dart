import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-axis.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class Window extends Viewable with SinglePropagator {
  late Iterable<Data2D> sortedData;
  late int lower, upper, length;
  late ViewAxis viewAxis;

  Window({GraphObject? child}) {
    Init.child(this, child);
  }

  @override
  void onView(ViewEvent viewEvent) {
    super.onView(viewEvent);
    sortedData = viewEvent.data;
    viewAxis = viewEvent.viewAxis;
    final truncatedIterables = truncateData();
    final event = ViewEvent(viewEvent, truncatedIterables);
    propagate(event);
  }

  Iterable<Data2D> truncateData() {
    defineBoudary();
    return makeIterator();
  }

  Iterable<Data2D> makeIterator() {
    return sortedData.skip(lower).take(length);
  }

  void defineBoudary() {
    upper = getUpperBound();
    lower = getLowerBound();
    length = upper - lower;
  }

  int maxChunk() {
    final zoneSize = baseDrawEvent!.drawZone.size;
    final chunkLength = viewAxis.chunkLength;
    final maxChunk = (zoneSize.width / chunkLength).ceil();

    return maxChunk;
  }

  int getUpperBound() {
    if (viewAxis.offset.dx <= 0) return sortedData.length;
    final skippedChunk = countSkippedChunk();
    final dataLen = sortedData.length;
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
    var lowerBound = upperBound - maxChunk();
    if (lowerBound <= 0) lowerBound = 0;

    return lowerBound;
  }
}
