import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';

class BasicGeometry extends UnitDrawable with SinglePropagator, DrawUnitObject {
  static const double BODY_PERCENT = 60;
  final double widthPercent = BODY_PERCENT;
  final DrawUnitObject? child;

  late final width;
  late final OHLC ohlc;

  BasicGeometry({this.child});

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    width = baseDrawEvent!.drawZone.size.width;
    ohlc = event.unitData.y as OHLC;
    drawCircle(ohlc.close);
  }

  void drawCircle(double closeValue) {
    final paint = Paint()..color = Colors.blue;
    final pixelClose = (baseDrawEvent as ViewEvent).yAxis.toPixel(ohlc.close);
    final center = baseDrawEvent!.drawZone.toRect.center.dx;
    canvas!.drawCircle(Offset(center, pixelClose), width, paint);
  }

  @override
  DrawUnitObject instanciate() => BasicGeometry(child: child?.instanciate());

  @override
  bool isHit(Offset hitPoint) {
    final center = Offset(baseDrawEvent!.drawZone.toRect.center.dx,
        (baseDrawEvent as ViewEvent).yAxis.toPixel(ohlc.close));
    final rect = Rect.fromCenter(center: center, width: width, height: width);
    return rect.contains(hitPoint);
  }
}
