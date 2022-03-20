import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/kernel/abstractKernel.dart';
import 'drawZone.dart';
import 'drawEvent.dart';
import 'object.dart';

class GraphKernel extends AbstractKernel {
  GraphObject? _objectToRepaint;

  GraphKernel({GraphObject? child}) : super(child);

  @override
  void paint(Canvas canvas, Size size) {
    final drawZone = new DrawZone(Offset.zero, size);
    final drawEvent = new DrawEvent(canvas, drawZone);
    propagate(drawEvent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (_objectToRepaint == null) return false;

    return true;
  }

  @override
  setState(GraphObject object) {
    notifyListeners();
    _objectToRepaint = object;
  }

  @override
  bool? hitTest(Offset position) => null;
  @override
  get semanticsBuilder => null;
  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
