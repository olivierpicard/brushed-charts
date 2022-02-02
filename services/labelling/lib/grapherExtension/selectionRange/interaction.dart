import 'package:grapher/cell/event.dart';
import 'package:grapher/cell/pointer-summary.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:labelling/grapherExtension/selectionRange/event.dart';

class SelectionRangeInteraction extends GraphObject with SinglePropagator {
  static const int _selectionIsOver = 2;
  static const int _readyToReselect = 3;
  // ignore: annotate_overrides, overridden_fields
  GraphObject? child;
  final range = List<DateTime?>.filled(2, null);
  var indexPointer = 0;

  SelectionRangeInteraction({this.child}) {
    eventRegistry.add(CellEvent, (p0) => onCellEvent(p0 as CellEvent));
  }

  void onCellEvent(CellEvent e) {
    if (e.datetime == null) return;
    onTap(e);
    if (indexPointer == _selectionIsOver) return;
    onHover(e);
    propagateRange();
  }

  void onTap(CellEvent event) {
    if (event.pointer.type != PointerType.Tap) return;
    indexPointer++;
    if (indexPointer == _readyToReselect) {
      indexPointer = 0;
      range[0] = null;
      range[1] = null;
    }
  }

  void onHover(CellEvent event) {
    if (event.pointer.type != PointerType.Hover) return;
    range[indexPointer] = event.datetime;
  }

  void propagateRange() {
    final event = SelectionRangeEvent(range[0], range[1]);
    propagate(event);
  }
}
