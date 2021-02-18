import 'package:flutter/widgets.dart';
import 'package:graph_kernel/sceneObject.dart';

class Scene implements CustomPainter {
  SceneObject _objectToRepaint;

  Scene({Container child});

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (_objectToRepaint == null) {
      return false;
    }
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
