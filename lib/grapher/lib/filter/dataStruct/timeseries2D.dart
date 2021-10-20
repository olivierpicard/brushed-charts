import 'data2D.dart';

abstract class Timeseries2D extends Data2D {
  final DateTime x;
  final dynamic y;
  Timeseries2D(this.x, this.y);

  @override
  bool tryToInsert(covariant Timeseries2D dataToInsert) {
    if (dataToInsert.timestamp < timestamp && previous == null) {
      insertBefore(dataToInsert);
      return true;
    }
    if (dataToInsert.timestamp > timestamp) {
      insertAfter(dataToInsert);
      return true;
    }
    if (dataToInsert.timestamp == timestamp) {
      insertBefore(dataToInsert);
      unlink();
      return true;
    }

    return false;
  }

  double get timestamp => x.millisecondsSinceEpoch as double;
  double toDouble() => timestamp;
}
