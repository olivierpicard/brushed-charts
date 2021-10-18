import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/geometry/geometry.dart';

class Histogram extends Geometry {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 1;

  late final double bodyWidth;
  late final OHLC ohlc;

  Histogram({DrawUnitObject? child}) : super(BODY_PERCENT, child);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    ohlc = event.unitData.y as OHLC;
  }

  MaterialColor getCandleColor(OHLC ohlc) {
    if (ohlc.open > ohlc.close) return Colors.red;
    return Colors.green;
  }

  @override
  DrawUnitObject instanciate() => Histogram(child: child?.instanciate());
}
