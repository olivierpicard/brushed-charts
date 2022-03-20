import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';

abstract class AxisObject extends Drawable with SinglePropagator {
  final double fontSize = 13;
  final GraphObject? child;

  ViewEvent? viewEvent;

  AxisObject(this.child) {
    eventRegistry.add(ViewEvent, (e) => onViewEvent(e));
  }

  void onViewEvent(ViewEvent event) {
    viewEvent = event;
  }

  @override
  void draw(DrawEvent event) {
    super.draw(event);
    drawBackground(event);
  }

  void drawBackground(DrawEvent event) {
    final zone = event.drawZone.toRect;
    final paint = Paint()..color = Colors.grey.shade900;
    canvas!.drawRect(zone, paint);
  }
}
