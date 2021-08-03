import 'package:grapher/view/window.dart';

class Bound {
  final Window win;
  late final int lower, upper, length;

  Bound(this.win) {
    this.lower = getLowerBound();
    this.upper = getUpperBound();
    this.length = upper - lower;
  }

  int maxDisplayableData() {
    final zoneSize = win.baseDrawEvent!.drawZone.size;
    return (zoneSize.width / win.baseChunkLength).ceil();
  }

  int getUpperBound() {
    if (win.xOffset <= 0) return win.sortedData.length - 1;
    final skipCounter = (win.xOffset / win.baseChunkLength).floor();
    final upperBound = win.sortedData.length - skipCounter - 1;

    return upperBound;
  }

  int getLowerBound() {
    final upperBound = getUpperBound();
    var lowerBound = upperBound - maxDisplayableData();
    if (lowerBound <= 0) lowerBound = 0;

    return lowerBound;
  }

  bool isValid() {
    if (upper <= lower) return false;
    return true;
  }
}
