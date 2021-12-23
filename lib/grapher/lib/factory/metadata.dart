import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/drawUnit/metadata.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

import 'drawzone.dart';
import 'factory.dart';

class MetadataHelper {
  static DrawUnitMetadata make(DrawUnitFactory fact, Data2D? item) {
    final viewEvent = _updateViewEvent(fact);
    final previous = _getPrevious(fact);
    final logicalPrevious = _getLogicalPrevious(fact);
    final metadata =
        DrawUnitMetadata(viewEvent, item, previous, logicalPrevious);

    return metadata;
  }

  static ViewEvent _updateViewEvent(DrawUnitFactory fact) {
    final drawZone = DrawZoneHelper.getUpdate(fact);
    final eventCopy = fact.viewEvent.copy();
    eventCopy.drawZone = drawZone;

    return eventCopy;
  }

  static DrawUnit? _getPrevious(DrawUnitFactory fact) {
    if (fact.children.length == 0) return null;
    final previousChunk = fact.children.last as DrawUnit;

    return previousChunk;
  }

  static DrawUnit? _getLogicalPrevious(DrawUnitFactory fact) {
    if (fact.children.length == 0) return null;
    final previous = fact.children.cast<DrawUnit?>().lastWhere(
        (drawUnit) => drawUnit!.metadata.data != null,
        orElse: () => null);

    return previous;
  }
}
