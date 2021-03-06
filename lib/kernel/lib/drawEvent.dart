import 'package:flutter/widgets.dart';
import 'package:kernel/propagator.dart';
import 'drawZone.dart';

class DrawEvent {
  final Propagator parent;
  final Canvas canvas;
  final DrawZone drawZone;

  DrawEvent(this.parent, this.canvas, this.drawZone);
}
