import 'dart:ui';

import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/propagator/endline.dart';
import 'package:pointer/helper/drag.dart';
import 'package:pointer/helper/hit.dart';

abstract class Handle extends FlexObject
    with EndlinePropagator, HitHelper, DragHelper {
  static const double THICKNESS = 10;
  static const COLOR = Colors.grey;
  final FlexObject? previous, next;

  double getDeltaDrag(DragUpdateDetails event);

  Handle(this.previous, this.next) {
    addEventListeners();
  }

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = COLOR;
    final rect = position & size;
    canvas.drawRect(rect, paint);
  }

  void onDrag(DragUpdateDetails event) {
    final deltaDrag = getDeltaDrag(event);
    previous?.length.bias += deltaDrag;
    next!.length.bias -= deltaDrag;
    setState(this);
  }
}
