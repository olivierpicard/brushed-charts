import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kernel/drawZone.dart';
import 'propagator.dart';
import 'drawEvent.dart';
import 'object.dart';

class GraphKernel with Propagator implements CustomPainter {
  GraphObject? _objectToRepaint;

  @override
  void paint(Canvas canvas, Size size) {
    final drawZone = new DrawZone(Offset.zero, size);
    final drawEvent = new DrawEvent(this, canvas, drawZone);
    propagate(drawEvent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (_objectToRepaint == null) return false;

    return true;
  }

  setState(GraphObject object) => _objectToRepaint = object;

  @override
  bool? hitTest(Offset position) => null;
  @override
  void addListener(listener) => null;
  @override
  void removeListener(listener) => null;
  @override
  get semanticsBuilder => null;
  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
