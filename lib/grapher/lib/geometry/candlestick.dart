import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/geometry/geometry.dart';

class Candlestick extends Geometry {
  static const double BODY_PERCENT = 60;
  static const double WICK_WIDTH = 1;

  late final double bodyWidth;
  late final OHLC ohlc;
  Rect? wick, body;

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
    body = Rect.fromLTRB(
        left, yAxis.toPixel(ohlc.close), right, yAxis.toPixel(ohlc.open));
    final paint = Paint()..color = getCandleColor(ohlc);
    canvas!.drawRect(body!, paint);
  }

  void drawWick(DrawUnitEvent event) {
    final left = _wickLeftSide;
    final right = _wickRightSide;
    final high = yAxis.toPixel(ohlc.high);
    final low = yAxis.toPixel(ohlc.low);
    wick = Rect.fromLTRB(left, high, right, low);
    final paint = Paint()..color = getCandleColor(ohlc);
    canvas!.drawRect(wick!, paint);
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

  Rect? makeContactZone() {
    if (body == null || wick == null) return null;
    return body!.expandToInclude(wick!);
  }

  @override
  DrawUnitObject instanciate() => Candlestick(child: child?.instanciate());
}
