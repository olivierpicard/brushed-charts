import 'package:flutter/widgets.dart';
import 'package:graph_kernel/cursor.dart';
import 'package:graph_kernel/event/drawEvent.dart';
import 'package:graph_kernel/sceneObject.dart';

class Scene implements CustomPainter {
  final children = <SceneObject>[];
  SceneObject _objectToRepaint;

  Scene({Container child});

  @override
  void paint(Canvas canvas, Size size) {
    final cursor = new Cursor(Offset.zero, size);
    final drawEvent = new DrawEvent(cursor, canvas);

    for (final child in children) {
      child.propagate(drawEvent);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (_objectToRepaint == null) return false;

    return true;
  }

  setState(SceneObject object) => _objectToRepaint = object;

  @override
  bool hitTest(Offset position) => null;
  @override
  void addListener(listener) => null;
  @override
  void removeListener(listener) => null;
  @override
  get semanticsBuilder => null;
  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
