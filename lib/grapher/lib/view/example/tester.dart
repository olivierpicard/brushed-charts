import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(
        IncomingData, (event) => onIncomingData(event as IncomingData));
  }

  void onIncomingData(IncomingData input) {
    final data = input.content as Iterable<Data2D>;
    print('first: ${data.first.x}');
    print('last: ${data.last.x}');
    print('count: ${data.length}');
    print("------");
  }
}
