import 'dart:ui';
import 'package:flutter/material.dart';

import '/kernel/drawable.dart';

mixin HitHelper on Drawable {
  void hitAddEventListeners() {
    eventRegistry.add(TapDownDetails, onTapDown);
  }

  void onTapDown(dynamic event);

  bool isHit(Offset pointer) {
    final position = baseDrawEvent?.drawZone.position;
    final size = baseDrawEvent?.drawZone.size;

    if (size == null || position == null) return false;
    final zoneSurface = position & size;

    return zoneSurface.contains(pointer);
  }
}
