import 'package:grapher/drawUnit/axis.dart';

import '../factory.dart';

class YAxisHelper {
  final DrawUnitFactory facto;
  late final Axis yAxis;

  YAxisHelper(this.facto) {
    final yMin = facto.viewEvent.viewAxis.yMin;
    final yMax = facto.viewEvent.viewAxis.yMax;
    final originalLen = yMax - yMin;
    final zoneHeight = facto.viewEvent.drawZone.size.height;
    final yScale = zoneHeight / originalLen;
    yAxis = Axis(yMin, yMax, yScale);
  }

  static Axis calculate(DrawUnitFactory facto) {
    return YAxisHelper(facto).yAxis;
  }
}
