import 'dart:math';

import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class YVirtualRangeUpdate extends Viewable with SinglePropagator {
  final GraphObject? child;

  YVirtualRangeUpdate({this.child});

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final range = YVirtualRangeUpdate.process(viewEvent.chainData);
    final newEvent = updateViewEvent(viewEvent, range);
    propagate(newEvent);
  }

  static Range process(Iterable<Data2D?> chain) {
    double yMin = 999999, yMax = -99999;
    for (final item in chain) {
      if (item == null || item.y == null) continue;
      yMin = min(item.yMin, yMin);
      yMax = max(item.yMax, yMax);
    }
    return Range(yMin, yMax);
  }

  ViewEvent updateViewEvent(ViewEvent originalEvent, Range range) {
    final event = originalEvent.copy();
    event.yAxis.virtualRange = range;
    return event;
  }
}
