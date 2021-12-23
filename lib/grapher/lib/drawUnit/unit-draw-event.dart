import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitEvent extends ViewEvent {
  final Data2D unitData;
  final DrawUnitObject? previous;
  final DrawUnitObject? logicalPrevious;

  DrawUnitEvent(
      ViewEvent baseEvent, this.unitData, this.previous, this.logicalPrevious)
      : super.copy(baseEvent);

  DrawUnitEvent.copy(DrawUnitEvent event)
      : unitData = event.unitData,
        previous = event.previous,
        logicalPrevious = event.logicalPrevious,
        super.copy(event);

  DrawUnitEvent copy() => DrawUnitEvent.copy(this);
}
