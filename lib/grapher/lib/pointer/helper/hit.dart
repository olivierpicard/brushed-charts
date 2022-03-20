import 'package:flutter/material.dart';

import '/kernel/drawable.dart';

mixin HitHelper on Drawable {
  void hitAddEventListeners() {
    eventRegistry.add(TapDownDetails, (e) => handleTap(e as TapDownDetails));
  }

  void handleTap(TapDownDetails event) {
    onTapDown(event);
    propagate(event);
  }

  void onTapDown(TapDownDetails event);

  bool isHit(Offset pointer) {
    final position = baseDrawEvent?.drawZone.position;
    final size = baseDrawEvent?.drawZone.size;

    if (size == null || position == null) return false;
    final zoneSurface = position & size;

    return zoneSurface.contains(pointer);
  }
}
