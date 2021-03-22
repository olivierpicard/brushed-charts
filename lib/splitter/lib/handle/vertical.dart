import 'package:flex/object.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class VerticalHandle extends Handle {
  VerticalHandle(FlexObject previous, FlexObject next) : super(previous, next);

  @override
  double getDeltaDrag(DragUpdateDetails event) => event.delta.dy;
}
