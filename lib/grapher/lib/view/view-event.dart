import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/view-axis.dart';

class ViewEvent extends DrawEvent {
  ViewAxis viewAxis;
  Iterable<Data2D?> chainData;

  // TODO: remove this constructor. If we create a an viewEvent
  // Based on another viewEvent it's a copy to change the chain data
  // It's not usefull anymore
  ViewEvent(ViewEvent event, this.chainData)
      : this.viewAxis = event.viewAxis,
        super(event.canvas, event.drawZone);

  ViewEvent.fromDrawEvent(DrawEvent drawEvent, this.viewAxis, this.chainData)
      : super(drawEvent.canvas, drawEvent.drawZone);

  ViewEvent.copy(ViewEvent event)
      : viewAxis = event.viewAxis.copy(),
        chainData = event.chainData,
        super.copy(event);

  ViewEvent copy() => ViewEvent.copy(this);
}
