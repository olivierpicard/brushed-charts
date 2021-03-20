import 'dart:ui';

import 'package:flex/length.dart';
import 'package:flutter/material.dart';

import 'object.dart';

class FlexResolver {
  final List<FlexObject> children;
  final double zoneLength;

  FlexResolver(this.children, this.zoneLength);

  double getLength(FlexObject child) {
    final flexLen = child.flexLength;
    if (!flexLen.isAuto) return flexLen.toPixel(zoneLength);

    return _getAutoLength(zoneLength);
  }

  double _getAutoLength(double zoneLength) {
    int countAuto = _countAutoChildren();
    double length = _occupiedScreen(zoneLength);
    final autoLength = (zoneLength - length) / countAuto;

    return autoLength;
  }

  int _countAutoChildren() {
    int counter = 0;
    for (final child in children) {
      if (child.flexLength.isAuto) counter++;
    }
    return counter;
  }

  double _occupiedScreen(double zoneLength) {
    double length = 0;
    for (final child in children) {
      if (child.flexLength.isAuto) continue;
      length += child.flexLength.toPixel(zoneLength);
    }
    return length;
  }
}
