import 'dart:ui';
import 'package:kernel/sizedObject.dart';
import 'sizeResolver.dart';

class VSizeResolver extends SizeResolver {
  VSizeResolver(List<SizedObject> children, Size baseDrawSize)
      : super(children, baseDrawSize);

  @override
  double getFiniteLength(SizedObject child) {
    final zoneSize = baseDrawSize;
    final length = child.flexSize.toPixels(zoneSize).height;

    return length;
  }

  @override
  Size getChildSize(SizedObject child) {
    if (child.flexSize.isFinite) {
      return child.flexSize.toPixels(baseDrawSize);
    }
    final autoLength = getAutoLength();
    final size = Size(baseDrawSize.width, autoLength);

    return size;
  }
}
