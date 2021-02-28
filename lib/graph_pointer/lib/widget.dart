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
        onHover: (hover) => print("hover : ${hover.localPosition}"),
        child: GestureDetector(
          onTapUp: (tap) => print("tap : ${tap.localPosition}"),
          onPanUpdate: (pan) => print("pan: ${pan.localPosition}"),
          child: this.child,
        ),
      ),
    );
  }

  onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    print("scroll: ${signal.scrollDelta}");
  }
}
