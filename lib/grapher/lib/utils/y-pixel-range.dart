import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class YPixelRangeUpdate extends Viewable with SinglePropagator {
  final GraphObject? child;

  YPixelRangeUpdate({this.child});

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final range = process();
    final newEvent = updateViewEvent(viewEvent, range);
    propagate(newEvent);
  }

  Range process() {
    final event = baseDrawEvent as ViewEvent;
    final zoneRect = event.drawZone.toRect;
    final yMin = zoneRect.top;
    final yMax = zoneRect.bottom;
    final range = Range(yMin, yMax);
    return range;
  }

  ViewEvent updateViewEvent(ViewEvent originalEvent, Range range) {
    final event = originalEvent.copy();
    event.yAxis.pixelRange = range;
    return event;
  }
}
