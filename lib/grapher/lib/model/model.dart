import 'dart:async';
import 'dart:collection';
import 'data2D.dart';

class Model {
  final data = LinkedList<Data2D>();

  Model({required Stream<Data2D> stream}) {
    stream.listen((data2D) => insert(data2D));
  }

  void insert(Data2D dataToInsert) {
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
