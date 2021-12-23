import 'package:grapher/filter/dataStruct/point.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pack/prune-event.dart';
import 'package:labelling/grapherExtension/selectionRange/event.dart';

class SelectionRangeData extends GraphObject with SinglePropagator {
  // ignore: annotate_overrides, overridden_fields
  GraphObject? child;
  SelectionRangeData({this.child}) {
    eventRegistry.add(SelectionRangeEvent, (p0) {
      onSelection(p0 as SelectionRangeEvent);
    });
  }

  onSelection(SelectionRangeEvent event) {
    propagate(PrunePacketEvent(tagNameToPrune: 'selection_range'));

    if (event.from == null) return;
    final from = Point2D(event.from!, 0);
    propagate(IncomingData(from));

    if (event.to == null) return;
    final to = Point2D(event.to!, 0);
    propagate(IncomingData(to));
  }
}
