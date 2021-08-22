import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';

class Candle2D extends Timeseries2D {
  double yMin, yMax;
  OHLC get y => super.y as OHLC;

  Candle2D(DateTime x, OHLC y)
      : yMin = y.low,
        yMax = y.high,
        super(x, y);
}
