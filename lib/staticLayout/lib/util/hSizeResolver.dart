import 'dart:ui';
import 'package:kernel/sizedObject.dart';
import 'sizeResolver.dart';

class HSizeResolver extends SizeResolver {
  HSizeResolver(List<SizedObject> children, Size baseDrawSize)
      : super(children, baseDrawSize);

  @override
  double getFiniteLength(SizedObject child) {
    final zoneSize = baseDrawSize;
    final length = child.flexSize.toPixels(zoneSize).width;

    return length;
  }

  @override
  Size getChildSize(SizedObject child) {
    if (child.flexSize.isFinite) {
      return child.flexSize.toPixels(baseDrawSize);
    }
    final autoLength = getAutoLength();
    final size = Size(autoLength, baseDrawSize.height);

    return size;
  }
}
