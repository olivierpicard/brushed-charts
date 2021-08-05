import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(ViewEvent, (event) => onEvent(event as ViewEvent));
  }

  void onEvent(ViewEvent event) {
    final data = event.data;
    print('first: ${data.first.x}');
    print('last: ${data.last.x}');
    print('count: ${data.length}');
    print('candleLen: ${event.viewAxis.chunkLength}');
    print("------");
  }
}
