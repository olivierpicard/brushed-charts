import 'package:flutter/material.dart';

import 'length.dart';
import 'package:kernel/drawable.dart';
import 'package:kernel/kernel.dart';

abstract class FlexObject extends Drawable {
  final FlexLength length;
  FlexObject({String length = "auto"}) : this.length = FlexLength(length);
}
