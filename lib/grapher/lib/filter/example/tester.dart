import 'dart:collection';

import '../dataStruct/data2D.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

import '../incoming-data.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(
        IncomingData, (event) => onIncomingData(event as IncomingData));
  }

  void onIncomingData(IncomingData input) {
    final data = input.content as LinkedList<Data2D>;
    final iterator = data.iterator;
    while (iterator.moveNext()) {
      print(iterator.current.x);
    }
    print("------");
  }
}
