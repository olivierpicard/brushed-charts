import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kernel/sizedObject.dart';

abstract class SizeResolver {
  @protected
  final List<SizedObject> children;
  @protected
  final Size baseDrawSize;

  SizeResolver(this.children, this.baseDrawSize);

  @protected
  double getFiniteLength(SizedObject child);
  Size getChildSize(SizedObject child);

  double getAutoLength() {
    final noSizeCounter = _countNoSizeChildren();
    final length = _occupiedScreenLength();
    final autoLength = (noSizeCounter == 0) ? length : length / noSizeCounter;

    return autoLength;
  }

  int _countNoSizeChildren() {
    int counter = 0;
    for (final child in children) {
      if (child.flexSize.isInfinite) counter++;
    }
    return counter;
  }

  double _occupiedScreenLength() {
    double length = 0;
    for (final child in children) {
      if (child.flexSize.isFinite) length += getFiniteLength(child);
    }
    return length;
  }
}
