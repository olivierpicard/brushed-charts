import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/utils/range.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher/view/view-axis.dart';

import 'axis/unit-axis.dart';

class ViewEvent extends DrawEvent {
  Iterable<Data2D?> chainData;
  ViewAxis viewAxis;
  VirtualAxis yAxis;
  UnitAxis xAxis;

  ViewEvent(DrawEvent drawEvent, this.viewAxis, this.chainData)
      : yAxis = VirtualAxis(
            Range(drawEvent.drawZone.position.dy,
                drawEvent.drawZone.endPosition().dy),
            viewAxis.yMin,
            viewAxis.yMax),
        xAxis = UnitAxis(
            Range(drawEvent.drawZone.position.dx,
                drawEvent.drawZone.endPosition().dx),
            viewAxis.unitLength),
        super(drawEvent.canvas, drawEvent.drawZone);

  ViewEvent.copy(ViewEvent event)
      : viewAxis = event.viewAxis.copy(),
        chainData = event.chainData,
        yAxis = VirtualAxis(
            Range(event.drawZone.position.dy, event.drawZone.endPosition().dy),
            event.viewAxis.yMin,
            event.viewAxis.yMax),
        xAxis = UnitAxis(
            Range(event.drawZone.position.dx, event.drawZone.endPosition().dx),
            event.viewAxis.unitLength),
        super.copy(event);

  ViewEvent copy() => ViewEvent.copy(this);
}
