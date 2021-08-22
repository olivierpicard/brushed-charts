import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/view-axis.dart';

class ViewEvent extends DrawEvent {
  final ViewAxis viewAxis;
  final Iterable<Data2D?> chainData;

  ViewEvent(ViewEvent event, this.chainData)
      : this.viewAxis = event.viewAxis,
        super(event.parent, event.canvas, event.drawZone);

  ViewEvent.fromDrawEvent(DrawEvent drawEvent, this.viewAxis, this.chainData)
      : super(drawEvent.parent, drawEvent.canvas, drawEvent.drawZone);
}
