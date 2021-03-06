import 'dart:ui';

import 'package:kernel/sizedObject.dart';

class FlexSize {
  Size virtual; // [0...1]
  Size pixel;

  FlexSize({this.pixel = Size.zero, this.virtual = Size.zero});

  Size toPixels(Size zoneSize) {
    final width = virtual.width * zoneSize.width + pixel.width;
    final height = virtual.height * zoneSize.height + pixel.height;

    return Size(width, height);
  }

  bool get isFinite => (virtual.isFinite && pixel.isFinite);
  bool get isInfinite => !isFinite;
}
