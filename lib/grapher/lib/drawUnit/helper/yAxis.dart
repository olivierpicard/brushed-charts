import 'package:grapher/drawUnit/axis.dart';

import '../factory.dart';

class YAxisHelper {
  final DrawUnitFactory facto;
  late final Axis yAxis;

  YAxisHelper(this.facto) {
    final min = getYMin();
    final max = getYMax();
    final originalLen = max - min;
    final zoneHeight = facto.viewEvent.drawZone.size.height;
    final yScale = zoneHeight / originalLen;
    yAxis = Axis(min, max, yScale);
  }

  static Axis calculate(DrawUnitFactory facto) {
    return YAxisHelper(facto).yAxis;
  }

  double getYMin() {
    final data = facto.viewEvent.chainData;
    final min = data.reduce((prev, curr) {
      return (prev.yMin < curr.yMin) ? prev : curr;
    }).yMin;

    return min;
  }

  double getYMax() {
    final data = facto.viewEvent.chainData;
    final max = data.reduce((prev, curr) {
      return (prev.yMax > curr.yMax) ? prev : curr;
    }).yMax;

    return max;
  }
}
