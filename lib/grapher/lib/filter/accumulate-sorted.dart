import 'dart:collection';
import 'package:grapher/kernel/object.dart';
import 'base.dart';
import 'dataStruct/data2D.dart';
import 'incoming-data.dart';

class SortAccumulation extends Filter {
  final sortedData = LinkedList<Data2D>();
  SortAccumulation({GraphObject? child}) : super(child) {}

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! Data2D) return;
    final data = input.content as Data2D;
    sort(data);
    propagate(IncomingData(sortedData));
  }

  void sort(Data2D input) {
    if (sortedData.length == 0) {
      sortedData.add(input);
      return;
    }
    Data2D? current = sortedData.last;
    while (current != null) {
      final isInsertionSucced = current.tryToInsert(input);
      if (isInsertionSucced) return;
      current = current.previous;
    }
  }
}
