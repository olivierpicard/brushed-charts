import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/view-axis.dart';

class ViewEvent extends DrawEvent {
  final ViewAxis viewAxis;
  final Iterable<Data2D>? data;

  ViewEvent(DrawEvent drawEvent, this.viewAxis, this.data)
      : super(drawEvent.parent, drawEvent.canvas, drawEvent.drawZone);
}
