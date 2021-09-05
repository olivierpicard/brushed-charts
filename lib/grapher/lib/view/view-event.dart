import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/utils/range.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher/view/view-axis.dart';

import 'axis/unit-axis.dart';

class ViewEvent extends DrawEvent {
  final Iterable<Data2D?> chainData;
  ViewAxis viewAxis;
  VirtualAxis yAxis;
  UnitAxis xAxis;

  // TODO: remove this constructor. If we create a an viewEvent
  // Based on another viewEvent it's a copy to change the chain data
  // It's not usefull anymore
  ViewEvent(ViewEvent event, this.chainData)
      : this.viewAxis = event.viewAxis,
        yAxis = VirtualAxis(
            event.drawZone.yRange, event.viewAxis.yMin, event.viewAxis.yMax),
        xAxis = UnitAxis(event.drawZone.xRange, event.viewAxis.unitLength),
        super(event.canvas, event.drawZone);

  ViewEvent.fromDrawEvent(DrawEvent drawEvent, this.viewAxis, this.chainData)
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
