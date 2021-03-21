import 'dart:ui';

import 'package:flex/object.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/propagator/endline.dart';

class HandleSplitter extends FlexObject with EndlinePropagator {
  static const double THICKNESS = 10;
  static const COLOR = Colors.grey;
  final FlexObject? previous, next;

  HandleSplitter(this.previous, this.next) {
    eventRegistry.add(DragUpdateDetails, onDrag);
  }

  void draw(covariant DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final size = drawEvent.drawZone.size;
    final position = drawEvent.drawZone.position;
    final paint = Paint()..color = COLOR;
    final rect = position & size;
    canvas.drawRect(rect, paint);
  }

  void onDrag(dynamic event) {
    DragUpdateDetails dragUpdate = event;
    final deltaDrag = dragUpdate.delta.dy;
    previous?.length.bias -= deltaDrag;
    next?.length.bias += deltaDrag;
    setState(this);
  }
}
