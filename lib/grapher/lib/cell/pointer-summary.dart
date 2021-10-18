import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum PointerType { Tap, Drag, Hover }

class PointerSummary {
  late final Offset position;
  late final Offset? delta;
  late final type;

  PointerSummary(dynamic pointerEvent) {
    if (pointerEvent is PointerHoverEvent) {
      summarizeHover(pointerEvent);
    } else if (pointerEvent is TapDownDetails) {
      summarizeTap(pointerEvent);
    } else if (pointerEvent is DragUpdateDetails) {
      summarizeDrag(pointerEvent);
    }
  }

  summarizeHover(PointerHoverEvent event) {
    position = event.position;
    delta = event.delta;
    type = PointerType.Hover;
  }

  summarizeTap(TapDownDetails event) {
    position = event.globalPosition;
    delta = null;
    type = PointerType.Tap;
  }

  summarizeDrag(DragUpdateDetails event) {
    position = event.globalPosition;
    delta = event.delta;
    type = PointerType.Drag;
  }
}
