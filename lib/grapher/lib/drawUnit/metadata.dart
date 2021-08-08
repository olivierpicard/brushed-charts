import 'package:grapher/drawUnit/axis.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitMetadata {
  final ViewEvent viewEvent;
  final Axis yAxis;
  final Data2D data;
  final DrawUnit? previous;

  DrawUnitMetadata(this.viewEvent, this.yAxis, this.data, this.previous);
}
