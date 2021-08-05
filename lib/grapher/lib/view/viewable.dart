import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/view/view-event.dart';

abstract class Viewable extends Drawable {
  Viewable() {
    eventRegistry.add(ViewEvent, (e) => onView(e as ViewEvent));
    eventRegistry.remove(DrawEvent);
  }

  void onView(ViewEvent viewEvent) {
    super.draw(viewEvent);
    baseDrawEvent = viewEvent;
  }
}
