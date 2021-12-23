import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/view/view-event.dart';

class DrawUnitMetadata {
  final ViewEvent viewEvent;
  final Data2D? data;
  final DrawUnit? previous;
  final DrawUnit? logicalPrevious;

  DrawUnitMetadata(
      this.viewEvent, this.data, this.previous, this.logicalPrevious);
}
