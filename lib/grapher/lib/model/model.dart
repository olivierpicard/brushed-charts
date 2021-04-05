import 'dart:async';
import 'dart:collection';

import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

import 'data2D.dart';

class Model extends GraphObject with EndlinePropagator {
  final linkedData = LinkedList<Data2D>();

  Model({required Stream<Data2D> stream}) {
    stream.listen((data2D) => insert(data2D));
  }

  void insert(Data2D dataToInsert) {
    try {
      reverseIterativeInsert(dataToInsert);
    } on StateError catch (_) {
      linkedData.add(dataToInsert);
    }
  }

  void reverseIterativeInsert(Data2D dataToInsert) {
    Data2D? node = linkedData.last;
    while (node != null) {
      final inserted = node.tryToInsert(dataToInsert);
      if (inserted) break;
      node = node.previous;
    }
  }
}
