import 'dart:ui';

import 'package:kernel/drawEvent.dart';
import 'package:kernel/drawable.dart';

mixin Hittable on Drawable {
  bool isHit(Offset pointer) {
    final position = baseDrawEvent?.drawZone.position;
    final size = baseDrawEvent?.drawZone.size;
    if (size == null || position == null) return false;
    final zoneSurface = position & size;
    return zoneSurface.contains(pointer);
  }
}
