import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/geometry/geometry.dart';

class Candlestick extends Geometry {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 1;

  late final double bodyWidth;
  late final OHLC ohlc;

  Candlestick({DrawUnitObject? child}) : super(BODY_PERCENT, child);

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    ohlc = event.unitData.y as OHLC;
    drawWick(event);
    drawBody(event);
  }

  void drawBody(DrawUnitEvent event) {
    final left = event.drawZone.toRect.left;
    final right = event.drawZone.toRect.right;
    final bodyRect = Rect.fromLTRB(
        left, yAxis.toPixel(ohlc.close), right, yAxis.toPixel(ohlc.open));
    final paint = Paint()..color = getCandleColor(ohlc);
    canvas!.drawRect(bodyRect, paint);
  }

  void drawWick(DrawUnitEvent event) {
    final left = _wickLeftSide;
    final right = _wickRightSide;
    final high = yAxis.toPixel(ohlc.high);
    final low = yAxis.toPixel(ohlc.low);
    final bodyRect = Rect.fromLTRB(left, high, right, low);
    final paint = Paint()..color = getCandleColor(ohlc);
    canvas!.drawRect(bodyRect, paint);
  }

  double get _wickLeftSide {
    final bodyWidth = baseDrawEvent!.drawZone.toRect;
    final bodyCenter = bodyWidth.center.dx;
    final wickLeftSide = bodyCenter - WICK_WIDTH / 2;

    return wickLeftSide;
  }

  double get _wickRightSide {
    final bodyWidth = baseDrawEvent!.drawZone.toRect;
    final bodyCenter = bodyWidth.center.dx;
    final wickRighSide = bodyCenter + WICK_WIDTH / 2;

    return wickRighSide;
  }

  MaterialColor getCandleColor(OHLC ohlc) {
    if (ohlc.open > ohlc.close) return Colors.red;
    return Colors.green;
  }

  @override
  DrawUnitObject instanciate() => Candlestick(child: child?.instanciate());
}
