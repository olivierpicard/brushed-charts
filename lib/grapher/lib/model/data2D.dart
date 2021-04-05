import 'dart:collection';

abstract class Data2D extends LinkedListEntry<Data2D> {
  dynamic get x;
  dynamic get y;
  bool tryToInsert(Data2D data);
  double toDouble();
}
