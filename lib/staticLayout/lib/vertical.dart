import 'dart:ui';

import 'package:flex/object.dart';
import 'package:flex/resolver.dart';
import 'package:kernel/drawEvent.dart';
import 'directional.dart';

class VerticalLayout extends DirectionalLayout {
  VerticalLayout({required List<FlexObject> children}) : super(children);

  @override
  void draw(covariant DrawEvent drawEvent) {
    final children = this.children as List<FlexObject>;
    super.resolver = FlexResolver(children, drawEvent.drawZone.size.height);
    super.draw(drawEvent);
  }

  Offset makeZonePosition(DrawEvent? lastEvent) {
    final x = baseDrawEvent!.drawZone.position.dx;
    final y = lastEvent?.drawZone.endPosition().dy ??
        baseDrawEvent!.drawZone.position.dy;

    return Offset(x, y);
  }

  @override
  Size defineObjectSize(double length) =>
      Size(baseDrawEvent!.drawZone.size.width, length);
}
