import '../factory.dart';

class YScaleHelper {
  final DrawUnitFactory facto;
  late final double scaleFactor;

  YScaleHelper(this.facto) {
    final min = getYMin();
    final max = getYMax();
    final originalLen = max - min;
    final zoneHeight = facto.viewEvent.drawZone.size.height;
    scaleFactor = zoneHeight / originalLen;
  }

  static double calculate(DrawUnitFactory facto) {
    return YScaleHelper(facto).scaleFactor;
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
