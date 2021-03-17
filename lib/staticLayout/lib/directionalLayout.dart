import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';
import 'package:kernel/sizedObject.dart';
import 'util/sizeResolver.dart';

abstract class DirectionalLayout extends SizedObject {
  final List<SizedObject> children = <SizedObject>[];
  late SizeResolver sizeResolver;

  DirectionalLayout(GraphKernel kernel) : super(kernel);

  Offset makeZonePosition(DrawEvent? lastEvent);

  DrawEvent makeDrawEvent(DrawEvent? lastDrawEvent, SizedObject child) {
    final zone = makeDrawZone(lastDrawEvent, child);
    final event = DrawEvent(this, baseDrawEvent!.canvas, zone);

    return event;
  }

  DrawZone makeDrawZone(DrawEvent? lastDrawEvent, SizedObject child) {
    final position = makeZonePosition(lastDrawEvent);
    final size = sizeResolver.getChildSize(child);
    final zone = DrawZone(position, size);

    return zone;
  }
}
