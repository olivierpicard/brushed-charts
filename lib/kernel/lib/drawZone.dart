import 'dart:ui';

class DrawZone {
  final Offset position;
  final Size size;

  static DrawZone copy(DrawZone cursor) => DrawZone(
      Offset(cursor.position.dx, cursor.position.dy),
      Size(cursor.size.width, cursor.size.height));

  DrawZone(this.position, this.size);

  Offset endPosition() =>
      Offset(position.dx + size.width, position.dy + size.height);
}
