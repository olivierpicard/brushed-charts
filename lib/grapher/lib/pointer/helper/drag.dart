import 'package:flutter/gestures.dart';
import 'package:grapher/kernel/drawable.dart';

mixin DragHelper on Drawable {
  bool isHold = false;

  void dragAddEventListeners() {
    // hitAddEventListeners();
    eventRegistry.add(DragEndDetails, onDragEnd);
    eventRegistry.add(DragUpdateDetails, onRawDrag);
    eventRegistry.add(DragDownDetails, onTapDownDrag);
  }

  void onDrag(DragUpdateDetails event);

  void onDragEnd(dynamic event) => isHold = false;

  void onTapDownDrag(dynamic event) {
    final pointerPosition = event.localPosition;
    final _isHit = isHit(pointerPosition);
    if (_isHit) isHold = true;
  }

  bool isHit(Offset pointer) {
    final position = baseDrawEvent?.drawZone.position;
    final size = baseDrawEvent?.drawZone.size;

    if (size == null || position == null) return false;
    final zoneSurface = position & size;

    return zoneSurface.contains(pointer);
  }

  void onRawDrag(dynamic event) {
    if (!isHold) return;
    onDrag(event);
    propagate(event);
  }
}
