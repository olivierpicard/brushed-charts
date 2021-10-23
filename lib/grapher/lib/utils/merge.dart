import 'dart:ui';

import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/drawUnit/unit-drawable.dart';

class MergeBranches extends UnitDrawable with SinglePropagator, DrawUnitObject {
  final GraphObject child;

  MergeBranches({required this.child});

  @override
  DrawUnitObject instanciate() => this;

  @override
  double get widthPercent => 0;

  @override
  bool isHit(Offset hitPoint) {
    throw UnimplementedError();
  }
}
