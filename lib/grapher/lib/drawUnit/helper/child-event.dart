import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/drawUnit/helper/child-drawzone.dart';
import 'package:grapher/drawUnit/metadata.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/view/view-event.dart';

class ChildUnitEvent {
  static DrawUnitEvent? make(DrawUnit unit) {
    if (unit.metadata.data == null) return null;
    final baseEvent = unit.baseDrawEvent! as ViewEvent;
    final metadata = unit.metadata;
    final drawZone = ChildDrawZone.make(unit);
    final childViewEvent = prepareChildEvent(baseEvent, drawZone);
    final childEvent = toDrawUnitEvent(childViewEvent, metadata);

    return childEvent;
  }

  static DrawUnitEvent? toDrawUnitEvent(
      ViewEvent baseEvent, DrawUnitMetadata metadata) {
    return DrawUnitEvent(baseEvent, metadata.data!, metadata.previous?.child,
        metadata.logicalPrevious?.child);
  }

  static ViewEvent prepareChildEvent(
      ViewEvent baseEvent, DrawZone childDrawZone) {
    final childEvent = baseEvent.copy();
    childEvent.drawZone = childDrawZone;

    return childEvent;
  }
}
