import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'align-options.dart';

class VAlignDrawZone extends GraphObject with SinglePropagator {
  final VAlign? alignment;
  final DrawZone originalZone, zone;
  final double bias;

  VAlignDrawZone(this.originalZone, this.zone, this.alignment,
      [this.bias = 0]) {
    updateZone();
  }

  void updateZone() {
    switch (alignment) {
      case VAlign.top:
        _alignTop();
        break;
      case VAlign.bottom:
        _alignBottom();
        break;
      default:
        break;
    }
  }

  void _alignTop() {
    final top = originalZone.toRect.top + bias;
    final left = zone.toRect.left;
    final position = Offset(left, top);
    zone.position = position;
  }

  void _alignBottom() {
    final bottom = originalZone.toRect.bottom - bias;
    final top = bottom - zone.size.height;
    final left = zone.toRect.left;
    final position = Offset(left, top);
    zone.position = position;
  }
}
