import 'dart:ui';

import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/propagator/endline.dart';
import 'package:pointer/hittable.dart';

abstract class Handle extends FlexObject with EndlinePropagator, Hittable {
  static const double THICKNESS = 10;
  static const COLOR = Colors.grey;
  final FlexObject? previous, next;

  double getDeltaDrag(DragUpdateDetails event);

  Handle(this.previous, this.next) {
    eventRegistry.add(DragUpdateDetails, onDrag);
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

  void onDrag(dynamic event) {
    DragUpdateDetails dragUpdate = event;
    final position = dragUpdate.localPosition;
    if (!isHit(position)) return;
    final deltaDrag = getDeltaDrag(dragUpdate);
    previous?.length.bias += deltaDrag;
    next?.length.bias -= deltaDrag;
    setState(this);
  }
}
