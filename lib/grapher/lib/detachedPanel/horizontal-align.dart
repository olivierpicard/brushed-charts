import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'align-options.dart';

class HAlignDrawZone extends GraphObject with SinglePropagator {
  final HAlign? alignment;
  final DrawZone originalZone, zone;
  final double bias;

  HAlignDrawZone(this.originalZone, this.zone, this.alignment,
      [this.bias = 0]) {
    updateZone();
  }

  void updateZone() {
    switch (alignment) {
      case HAlign.left:
        _alignLeft();
        break;
      case HAlign.right:
        _alignRight();
        break;
      default:
        break;
    }
  }

  void _alignLeft() {
    final left = originalZone.toRect.left + bias;
    final top = zone.toRect.top;
    final position = Offset(left, top);
    zone.position = position;
  }

  void _alignRight() {
    final right = originalZone.toRect.right - bias;
    final left = right - zone.size.width;
    final top = zone.toRect.top;
    final position = Offset(left, top);
    zone.position = position;
  }
}
