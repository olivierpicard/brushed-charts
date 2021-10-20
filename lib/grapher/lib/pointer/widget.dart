import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grapher/kernel/widget.dart';
import 'package:grapher/pointer/hover-wrapper.dart';
import 'package:grapher/pointer/scroll-wrapper.dart';
import '/kernel/kernel.dart';

class GraphPointer extends StatelessWidget {
  final Widget? child;
  final GraphKernel kernel;
  GraphPointer({required this.kernel, this.child});

  Widget build(BuildContext context) {
    return Listener(
        onPointerSignal: onScrollableEvent,
        onPointerHover: onHover,
        child: GestureDetector(
            onPanUpdate: kernel.propagate,
            onTapUp: kernel.propagate,
            onTapDown: kernel.propagate,
            onPanEnd: kernel.propagate,
            onPanDown: kernel.propagate,
            child: Graph(kernel: kernel, child: child)));
  }

  void onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    kernel.propagate(PointerScrollEventWrapper(signal));
  }

  void onHover(PointerHoverEvent event) {
    final hover = PointerHoverEventWrapper(event);
    kernel.propagate(hover);
  }
}
