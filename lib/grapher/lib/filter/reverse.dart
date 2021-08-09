import 'dart:collection';
import 'package:grapher/kernel/object.dart';
import 'base.dart';
import 'dataStruct/data2D.dart';
import 'incoming-data.dart';

class ReverseData extends Filter {
  final reversedList = LinkedList<Data2D>();
  ReverseData({GraphObject? child}) : super(child);

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! LinkedList<Data2D>) return;
    final data = input.content as LinkedList<Data2D>;
    final reversed = data.toList().reversed;
    propagate(IncomingData(reversed));
  }
}
