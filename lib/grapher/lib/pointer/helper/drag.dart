import 'package:flutter/gestures.dart';
import 'hit.dart';

mixin DragHelper on HitHelper {
  bool isHold = false;

  void dragAddEventListeners() {
    hitAddEventListeners();
    eventRegistry.add(DragEndDetails, onDragEnd);
    eventRegistry.add(DragUpdateDetails, onRawDrag);
    eventRegistry.add(DragDownDetails, onTapDown);
  }

  void onDrag(DragUpdateDetails event);

  void onTapDown(dynamic event) {
    final pointerPosition = event.localPosition;
    final _isHit = isHit(pointerPosition);
    if (_isHit) isHold = true;
  }

  void onDragEnd(dynamic event) => isHold = false;

  void onRawDrag(dynamic event) {
    if (!isHold) return;
    onDrag(event);
  }
}
