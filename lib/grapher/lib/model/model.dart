import 'dart:collection';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'data2D.dart';
import 'event/incoming-data.dart';

class Model extends GraphObject with SinglePropagator {
  final data = LinkedList<Data2D>();

  Model({GraphObject? child}) {
    Init.child(this, child);
    eventRegistry.add(
        IncomingData, (data) => onIncommingData(data as IncomingData));
  }

  void onIncommingData(IncomingData input) {
    insert(input);
    propagate(IncomingData(this.data));
  }

  void insert(IncomingData input) {
    if (input.content is! Data2D) return;
    final dataToInsert = input.content;
    try {
      reverseIterativeInsert(dataToInsert);
    } on StateError catch (_) {
      data.add(dataToInsert);
    }
  }

  void reverseIterativeInsert(Data2D dataToInsert) {
    Data2D? node = data.last;
    while (node != null) {
      final inserted = node.tryToInsert(dataToInsert);
      if (inserted) break;
      node = node.previous;
    }
  }
}
