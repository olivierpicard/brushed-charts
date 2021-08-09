import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/drawUnit/instanciable.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class Candlestick extends Geometry with EndlinePropagator {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 2;

  late final double bodyWidth;
  late final OHLC ohlc;

  Candlestick() : super(BODY_PERCENT);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    ohlc = event.unitData.y as OHLC;
    bodyWidth = event.width;
    drawWick(event);
    drawBody(event);
  }

  void drawBody(DrawUnitEvent event) {
    final bodyRect = Rect.fromLTRB(0, ohlc.close, bodyWidth, ohlc.open);
    final paint = Paint()..color = getBodyColor(ohlc);
    canvas!.drawRect(bodyRect, paint);
  }

  MaterialColor getBodyColor(OHLC ohlc) {
    if (ohlc.open > ohlc.close) return Colors.red;
    return Colors.green;
  }

  void drawWick(DrawUnitEvent event) {
    final left = _wickLeftPosition;
    final right = _wickRightPosition;
    final bodyRect = Rect.fromLTRB(left, ohlc.high, right, ohlc.low);
    final paint = Paint()..color = Colors.grey;
    canvas!.drawRect(bodyRect, paint);
  }

  double get _wickLeftPosition => bodyWidth / 2 - WICK_WIDTH / 2;
  double get _wickRightPosition => bodyWidth / 2 + WICK_WIDTH / 2;

  @override
  DrawUnitObject instanciate() => Candlestick();
}
