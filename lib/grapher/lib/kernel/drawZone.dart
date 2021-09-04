import 'dart:ui';

class DrawZone {
  Offset position;
  Size size;

  DrawZone.copy(DrawZone ref)
      : position = ref.position,
        size = ref.size;

  DrawZone(this.position, this.size);

  DrawZone copy() => DrawZone.copy(this);

  Offset endPosition() => toRect.bottomRight;
  Rect get toRect => position & size;
}
