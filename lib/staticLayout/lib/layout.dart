import 'dart:ffi';
import 'dart:ui';

import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';
import 'package:kernel/sizedObject.dart';
import 'package:tuple/tuple.dart';

enum LayoutDirection { Vertical, Horizontal }

abstract class DirectionalLayout extends SizedObject {
  final LayoutDirection direction;
  final List<SizedObject> children = <SizedObject>[];
  DirectionalLayout(GraphKernel kernel, {required this.direction})
      : super(kernel);

  draw(covariant DrawEvent event) {}

  double resolveChildSpace(SizedObject childToResolve, Size zoneSize) {
    Double spaceTaken;
    var counterInfiniteChild = 0;

    for (final child in children) {
      updateSpaceTake(child, spaceTaken);
      final childSize = child.flexSize;

      if (childSize.isInfinite)
        counterInfiniteChild++;
      else
        spaceTaken += getSpaceByDirection(childSize, zoneSize);
    }

    final totalSpace = (direction == LayoutDirection.Vertical)
        ? zoneSize.height
        : zoneSize.width;
    final spaceLeft = totalSpace - spaceTaken;
    final childSize = spaceLeft / counterInfiniteChild;

    return childSize;
  }

  double updateSpaceTake(SizedObject object) {
    double space = 0;
    if (object.flexSize.isFinite) return space;
    final objectSize = object.flexSize;
  }

  double getSpaceByDirection(FlexSize flexSize, Size zoneSize) {
    double space = 0;
    final size = flexSize.toPixels(zoneSize);
    if (direction == LayoutDirection.Vertical)
      space += size.height;
    else
      space += size.width;

    return space;
  }
}
