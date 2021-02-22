import 'package:flutter/material.dart';
import 'scene.dart';

class SceneWidget extends StatelessWidget {
  final Widget child;

  SceneWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Scene(),
      child: this.child,
    );
  }
}
