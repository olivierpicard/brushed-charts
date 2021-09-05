import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';

abstract class Geometry extends UnitDrawable
    with EndlinePropagator, DrawUnitObject {
  final double widthPercent;
  late final VirtualAxis yAxis;
  late final UnitAxis xAxis;

  Geometry(this.widthPercent);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    yAxis = event.yAxis;
    xAxis = event.xAxis;
  }
}
