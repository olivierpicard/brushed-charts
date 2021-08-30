import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class FakeTemplate extends UnitDrawable with EndlinePropagator, DrawUnitObject {
  final double widthPercent = 80;

  @override
  DrawUnitObject instanciate() => FakeTemplate();
}
