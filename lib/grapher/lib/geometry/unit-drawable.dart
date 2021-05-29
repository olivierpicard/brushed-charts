import 'package:grapher/kernel/drawable.dart';
import 'draw-unit-event.dart';

abstract class UnitDrawable extends Drawable {
  UnitDrawable() {}

  @override
  void draw(covariant DrawUnitEvent event) {
    super.draw(event);
  }
}
