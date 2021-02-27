import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'cursor.dart';
import 'drawEvent.dart';
import 'sceneObject.dart';

class Scene implements CustomPainter {
  final children = <SceneObject>[];
  SceneObject? _objectToRepaint;

  @override
  void paint(Canvas canvas, Size size) {
    final cursor = new Cursor(Offset.zero, size);
    final drawEvent = new DrawEvent(cursor, canvas);

    for (final child in children) {
      child.propagate(drawEvent);
    }

    var painter = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    var rect = Offset.zero & size;
    canvas.drawRect(rect, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (_objectToRepaint == null) return false;

    return true;
  }

  setState(SceneObject object) => _objectToRepaint = object;

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
