import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';

abstract class UnitDrawable extends Drawable {
  UnitDrawable() {
    eventRegistry.add(DrawUnitEvent, (e) => draw(e as DrawUnitEvent));
    eventRegistry.remove(DrawEvent);
  }

  void draw(covariant DrawUnitEvent event) {
    super.draw(event);
  }
}
