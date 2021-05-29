import 'package:flutter/material.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'draw-unit-event.dart';

typedef GeometryInstanciator = Geometry Function(Data2D);

abstract class Geometry extends Drawable with EndlinePropagator {
  final Data2D data;

  Geometry({required this.data});

  @override
  void draw(covariant DrawUnitEvent drawEvent) {
    final cursor = drawEvent.cursor;
    drawEvent.canvas.drawRect(
        Rect.fromCenter(
            center: Offset(cursor, 0), width: drawEvent.length / 2, height: 50),
        Paint()..color = Colors.red);
  }
}
