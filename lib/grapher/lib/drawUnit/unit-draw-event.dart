import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitEvent extends ViewEvent {
  final Data2D unitData;
  final DrawUnitObject? previous;
  // TODO: Remove width because DrawUnit has it's own adjusted DrawZone
  double width;

  DrawUnitEvent(ViewEvent baseEvent, this.unitData, this.width, this.previous)
      : super(baseEvent, baseEvent.chainData);

  DrawUnitEvent.copy(DrawUnitEvent event)
      : unitData = event.unitData,
        previous = event.previous,
        width = event.width,
        super.copy(event);

  DrawUnitEvent copy() => DrawUnitEvent.copy(this);
}
