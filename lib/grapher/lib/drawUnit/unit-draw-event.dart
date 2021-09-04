import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitEvent extends ViewEvent {
  final Data2D unitData;
  final DrawUnitObject? previous;
  final double width;

  DrawUnitEvent(ViewEvent baseEvent, this.unitData, this.width, this.previous)
      : super(baseEvent, baseEvent.chainData);
}
