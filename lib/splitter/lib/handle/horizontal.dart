import 'package:flex/object.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class HorizontalHandle extends Handle {
  HorizontalHandle(FlexObject previous, FlexObject next)
      : super(previous, next);

  @override
  double getDeltaDrag(DragUpdateDetails event) => event.delta.dx;
}
