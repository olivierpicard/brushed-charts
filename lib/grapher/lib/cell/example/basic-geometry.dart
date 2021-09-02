import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/unit-draw-event.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/kernel/propagator/single.dart';

class BasicGeometry extends UnitDrawable with SinglePropagator, DrawUnitObject {
  static const double BODY_PERCENT = 60;
  final double widthPercent = BODY_PERCENT;

  late final double bodyWidth;
  late final OHLC ohlc;

  BasicGeometry();

  @override
  void draw(DrawUnitEvent event) {
    super.draw(event);
    ohlc = event.unitData.y as OHLC;
    bodyWidth = event.width;
    drawCircle(ohlc.close);
  }

  void drawCircle(double closeValue) {
    print(bodyWidth / 2);
    final paint = Paint()..color = Colors.blue;

    canvas!.drawCircle(Offset(0, closeValue), bodyWidth, paint);
  }

  @override
  DrawUnitObject instanciate() => BasicGeometry();
}
