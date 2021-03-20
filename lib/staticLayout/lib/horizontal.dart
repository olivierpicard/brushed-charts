import 'dart:ui';

import 'package:flex/resolver.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/kernel.dart';
import 'directional.dart';

class HorizontalLayout extends DirectionalLayout {
  HorizontalLayout(GraphKernel kernel) : super(kernel);

  @override
  void draw(covariant DrawEvent drawEvent) {
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
