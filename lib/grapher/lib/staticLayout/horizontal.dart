import 'dart:ui';

import '/flex/object.dart';
import '/flex/resolver.dart';
import '/kernel/drawEvent.dart';
import 'directional.dart';

class HorizontalLayout extends DirectionalLayout {
  HorizontalLayout({required List<FlexObject> children}) : super(children);

  @override
  void draw(covariant DrawEvent drawEvent) {
    final children = this.children as List<FlexObject>;
    resolver = FlexResolver(children, drawEvent.drawZone.size.width);
    super.draw(drawEvent);
  }

  Offset makeZonePosition(DrawEvent? lastEvent) {
    final y = baseDrawEvent!.drawZone.position.dy;
    final x = lastEvent?.drawZone.endPosition().dx ??
        baseDrawEvent!.drawZone.position.dx;

    return Offset(x, y);
  }

  @override
  Size defineObjectSize(double length) =>
      Size(length, baseDrawEvent!.drawZone.size.height);
}
