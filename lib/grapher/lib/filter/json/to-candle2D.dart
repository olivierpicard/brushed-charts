import 'package:grapher/filter/dataStruct/candle.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/filter/json/to-timeseries2D.dart';
import 'package:grapher/kernel/object.dart';

class ToCandle2D extends ToTimeseries2D {
  ToCandle2D(
      {required String xLabel, required String yLabel, GraphObject? child})
      : super(xLabel, yLabel, child);

  @override
  Timeseries2D instanciate(
      DateTime dateTime, covariant Map<String, dynamic> y) {
    final ohlc = OHLC(y);
    final candle = Candle2D(dateTime, ohlc);
    return candle;
  }
}
