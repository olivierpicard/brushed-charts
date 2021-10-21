import 'dart:ui';

import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class ResizeDrawZone extends GraphObject with SinglePropagator {
  final double? width;
  final double? height;
  final DrawZone zone;

  ResizeDrawZone(this.zone, this.width, this.height) {
    updateZone();
  }

  void updateZone() {
    _updateHeight();
    _updateWidth();
  }

  void _updateHeight() {
    if (height == null) return;
    final zoneWidth = zone.size.width;
    zone.size = Size(zoneWidth, height!);
  }

  void _updateWidth() {
    if (width == null) return;
    final zoneHeight = zone.size.height;
    zone.size = Size(width!, zoneHeight);
  }
}
