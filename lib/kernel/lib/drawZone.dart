import 'dart:ui';

class DrawZone {
  Offset position;
  Size size;

  DrawZone(this.position, this.size);

  static DrawZone copy(DrawZone cursor) => DrawZone(
      Offset(cursor.position.dx, cursor.position.dy),
      Size(cursor.size.width, cursor.size.height));
}
