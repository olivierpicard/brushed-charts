import 'package:grapher/cell/event.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(CellEvent, (e) => handleCellEvent(e as CellEvent));
  }

  void handleCellEvent(CellEvent event) {
    print(event.datetime);
  }
}
