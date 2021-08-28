import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitEvent extends ViewEvent {
  final Data2D unitData;
  final DrawUnitObject? previous;
  final DrawUnit parent;
  final double width;
  final double yScale;

  DrawUnitEvent(ViewEvent baseEvent, this.unitData, this.width, this.yScale,
      this.parent, this.previous)
      : super(baseEvent, baseEvent.chainData);
}
