import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/axis/virtual-axis.dart';

import 'axis/unit-axis.dart';

class ViewEvent extends DrawEvent {
  Iterable<Data2D?> chainData;
  VirtualAxis yAxis;
  UnitAxis xAxis;

  ViewEvent(DrawEvent drawEvent, this.xAxis, this.yAxis, this.chainData)
      : super(drawEvent.canvas, drawEvent.drawZone);

  ViewEvent.copy(ViewEvent event)
      : chainData = event.chainData,
        yAxis = event.yAxis.copy(),
        xAxis = event.xAxis.copy(),
        super.copy(event);

  ViewEvent copy() => ViewEvent.copy(this);
}
