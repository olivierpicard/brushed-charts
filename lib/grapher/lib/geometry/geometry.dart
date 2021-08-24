import 'package:grapher/drawUnit/instanciable.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';

abstract class Geometry extends UnitDrawable
    with EndlinePropagator, DrawUnitObject {
  final double widthPercent;

  Geometry(this.widthPercent);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
  }
}
