import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
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
            drawEvent.drawZone.yRange, viewAxis.yMin, viewAxis.yMax),
        xAxis = UnitAxis(drawEvent.drawZone.xRange, viewAxis.unitLength),
        super(drawEvent.canvas, drawEvent.drawZone);

  ViewEvent.copy(ViewEvent event)
      : viewAxis = event.viewAxis.copy(),
        chainData = event.chainData,
        yAxis = VirtualAxis(
            event.drawZone.yRange, event.viewAxis.yMin, event.viewAxis.yMax),
        xAxis = UnitAxis(event.drawZone.xRange, event.viewAxis.unitLength),
        super.copy(event);

  ViewEvent copy() => ViewEvent.copy(this);
}
