import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'linkEvent.dart';
import 'propagator/single.dart';
import 'drawZone.dart';
import 'misc/Init.dart';
import 'drawEvent.dart';
import 'object.dart';

class GraphKernel extends ChangeNotifier
    with SinglePropagator, GraphObject
    implements CustomPainter {
  GraphObject? _objectToRepaint;

  GraphKernel({GraphObject? child}) {
    Init.child(this, child);
    kernel = this;
    propagate(KernelLinkEvent(this));
  }

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
