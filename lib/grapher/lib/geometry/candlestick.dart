import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/model/data2D.dart';
import 'package:grapher/model/timeseries2D.dart';

class Candlestick extends Geometry with EndlinePropagator {
  Candlestick({required Data2D data}) : super(data: data);

  static Candlestick instanciate(Data2D data) {
    return Candlestick(data: data);
  }
}
