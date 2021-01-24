import 'package:brushed_charts_graphql/main.dart' as graphql;
import 'package:flutter/material.dart';

class Scene implements CustomPainter {
  Scene() {}

  @override
  void addListener(listener) {}

  @override
  bool hitTest(Offset position) {
    print('hittest');
  }

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void removeListener(listener) => null;

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
