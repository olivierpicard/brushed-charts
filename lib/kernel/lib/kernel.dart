import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'propagator.dart';
import 'cursor.dart';
import 'drawEvent.dart';
import 'object.dart';

class GraphKernel implements CustomPainter, Propagator {
  final children = <GraphObject>[];
  GraphObject? _objectToRepaint;

  @override
  void paint(Canvas canvas, Size size) {
    final cursor = new Cursor(Offset.zero, size);
    final drawEvent = new DrawEvent(cursor, canvas);
    propagate(drawEvent);

    var painter = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    var rect = Offset.zero & size;
    canvas.drawRect(rect, painter);
  }

  @override
  void propagate(event) {
    print(event.runtimeType);
    for (final child in children) {
      child.propagate(event);
    }
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
