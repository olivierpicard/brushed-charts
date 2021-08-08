import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitMetadata {
  final ViewEvent viewEvent;
  final double yScale;
  final Data2D data;
  final DrawUnit? previous;

  DrawUnitMetadata(this.viewEvent, this.yScale, this.data, this.previous);
}
