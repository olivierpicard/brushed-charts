import 'package:grapher/filter/dataStruct/point.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/filter/json/to-timeseries2D.dart';
import 'package:grapher/kernel/object.dart';

class ToPoint2D extends ToTimeseries2D {
  ToPoint2D(
      {required String xLabel, required String yLabel, GraphObject? child})
      : super(xLabel, yLabel, child);

  @override
  Timeseries2D instanciate(DateTime dateTime, covariant double y) {
    final point = Point2D(dateTime, y);
    return point;
  }
}
