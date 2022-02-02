import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grapher/kernel/widget.dart';
import 'package:grapher/pointer/hover-wrapper.dart';
import 'package:grapher/pointer/scroll-wrapper.dart';
import '/kernel/kernel.dart';

class GraphFullInteraction extends StatefulWidget {
  final Widget? child;
  final GraphKernel kernel;
  GraphFullInteraction({required this.kernel, this.child});

  @override
  State<StatefulWidget> createState() {
    return _GraphFullInteraction();
  }
}

class _GraphFullInteraction extends State<GraphFullInteraction> {
  final focusNode = FocusNode();

  Widget build(BuildContext context) {
    return KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: onKeyStroke,
        child: Listener(
            onPointerSignal: onScrollableEvent,
            onPointerHover: onHover,
            child: GestureDetector(
                onPanUpdate: widget.kernel.propagate,
                onTapUp: (p0) => onTapUp(p0),
                onTapDown: widget.kernel.propagate,
                onPanEnd: widget.kernel.propagate,
                onPanDown: widget.kernel.propagate,
                child: Graph(kernel: widget.kernel, child: widget.child))));
  }

  void onKeyStroke(KeyEvent event) {
    if (event.character == null) return;
    if (event is! KeyDownEvent) return;
    widget.kernel.propagate(event);
  }

  void onTapUp(TapUpDetails tap) {
    focusNode.requestFocus();
    widget.kernel.propagate(tap);
  }

  void onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    widget.kernel.propagate(PointerScrollEventWrapper(signal));
  }

  void onHover(PointerHoverEvent event) {
    final hover = PointerHoverEventWrapper(event);
    widget.kernel.propagate(hover);
  }
}
