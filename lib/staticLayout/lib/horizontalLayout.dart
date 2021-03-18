import 'dart:ui';

import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';
import 'directionallayout.dart';
import 'util/hSizeResolver.dart';

abstract class HorizontalLayout extends DirectionalLayout {
  HorizontalLayout(GraphKernel kernel) : super(kernel);

  @override
  void draw(covariant DrawEvent drawEvent) {
    sizeResolver = HSizeResolver(children, drawEvent.drawZone.size);
    super.draw(drawEvent);
  }

  Offset makeZonePosition(DrawEvent? lastEvent) {
    final y = baseDrawEvent!.drawZone.position.dy;
    final x = lastEvent?.drawZone.endPosition().dx ??
        baseDrawEvent!.drawZone.position.dx;

    return Offset(x, y);
  }
}
