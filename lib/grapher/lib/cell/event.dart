import 'package:grapher/cell/cell.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/view/view-event.dart';

class CellEvent {
  final ViewEvent viewEvent;
  final DrawUnitObject child;
  final DrawZone drawZone;
  final Cell cell;
  final Timeseries2D? data;
  final dynamic pointerEvent;
  final DateTime? datetime;

  CellEvent(this.cell, this.pointerEvent)
      : viewEvent = cell.baseDrawEvent! as ViewEvent,
        drawZone = cell.baseDrawEvent!.drawZone,
        data = cell.metadata.data as Timeseries2D,
        child = cell.child,
        datetime = cell.metadata.data?.x;
}
