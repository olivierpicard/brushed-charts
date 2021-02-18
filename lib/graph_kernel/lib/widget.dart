import 'package:flutter/material.dart';
import 'scene.dart';

class GraphWidget extends StatelessWidget {
  final Widget child;

  GraphWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Scene(),
      child: this.child,
    );
  }
}
