import 'package:flutter/gestures.dart';
import 'hit.dart';

mixin DragHelper on HitHelper {
  bool isHold = false;

  void addEventListeners() {
    eventRegistry.add(TapDownDetails, onTapDown);
    eventRegistry.add(TapUpDetails, onTapUp);
    // eventRegistry.add(TapCancelEvent, onTapCancel);
    eventRegistry.add(DragUpdateDetails, onRawDrag);
  }

  void onDrag(DragUpdateDetails event);

  void onTapDown(dynamic event) {
    final tapEvent = event as TapDownDetails;
    final pointerPosition = tapEvent.localPosition;
    final _isHit = isHit(pointerPosition);
    if (_isHit) isHold = true;
  }

  void onTapUp(dynamic event) => isHold = false;

  void onTapCancel(dynamic event) => isHold = false;

  void onRawDrag(dynamic event) {
    if (!isHold) return;
    onDrag(event);
  }
}
