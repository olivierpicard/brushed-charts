import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graph_kernel/propagator.dart';

class GraphPointer extends StatelessWidget {
  final Widget child;
  final Propagator propagator;

  GraphPointer({required this.propagator, required this.child});

  Widget build(BuildContext context) {
    return Listener(
        onPointerSignal: onScrollableEvent,
        child: MouseRegion(
            onHover: propagator.propagate,
            child: GestureDetector(
                onPanUpdate: propagator.propagate,
                onTapUp: propagator.propagate,
                onTapDown: propagator.propagate,
                child: this.child)));
  }

  onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    propagator.propagate(signal);
  }
}
