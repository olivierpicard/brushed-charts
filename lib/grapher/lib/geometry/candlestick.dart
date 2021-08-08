import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/drawUnit/instanciable.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class Candlestick extends Geometry with EndlinePropagator {
  static const double BODY_PERCENT = 80;
  static const double WICK_WIDTH = 3;
  Candlestick() : super(BODY_PERCENT);

  @override
  void draw(DrawUnitEvent event) {
    final canvas = event.canvas;
    final ohlc = event.unitData.y as OHLC;
    final bodyWidth = event.width;
    final body = Rect.fromLTRB(0, ohlc.close, bodyWidth, ohlc.open);
    final wick = Rect.fromLTRB(bodyWidth / 2 - WICK_WIDTH / 2, ohlc.high,
        bodyWidth / 2 - WICK_WIDTH / 2, ohlc.low);
    canvas.drawRect(body, getColor(ohlc));
    canvas.drawRect(wick, Paint()..color = Colors.grey);
  }

  Paint getColor(OHLC ohlc) {
    if (ohlc.open < ohlc.close) return Paint()..color = Colors.red;
    return Paint()..color = Colors.green;
  }

  @override
  DrawUnitObject instanciate() => Candlestick();
}
