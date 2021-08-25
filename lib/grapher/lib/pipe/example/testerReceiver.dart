import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/pipe/example/testEvent.dart';

class TesterReceiver extends GraphObject with EndlinePropagator {
  TesterReceiver() {
    eventRegistry.add(TestEvent, (e) => handleTestEvent(e as TestEvent));
  }

  void handleTestEvent(TestEvent event) {
    if (event.name == "an event") {
      print("Test succeed");
    }
  }
}
