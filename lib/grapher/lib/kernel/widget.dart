import 'package:flutter/material.dart';
import 'kernel.dart';

class Graph extends StatelessWidget {
  final Widget child;
  final GraphKernel kernel;

  Graph({required this.kernel, Widget? child})
      : this.child = child ?? Container();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: kernel,
      child: this.child,
    );
  }
}
