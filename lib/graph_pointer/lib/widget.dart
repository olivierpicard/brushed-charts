import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graph_kernel/main.dart';

class GraphPointer extends StatelessWidget {
  final Widget? child;
  final GraphKernel kernel;

  GraphPointer({required this.kernel, this.child});

  Widget build(BuildContext context) {
    return Listener(
        onPointerSignal: onScrollableEvent,
        child: MouseRegion(
            onHover: kernel.propagate,
            child: GestureDetector(
                onTapUp: kernel.propagate,
                onPanUpdate: kernel.propagate,
                child: this.child)));
  }

  onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    kernel.propagate(signal);
  }
}
