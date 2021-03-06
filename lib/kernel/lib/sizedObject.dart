import 'dart:ui';
import 'package:kernel/drawable.dart';
import 'package:kernel/flexSize.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/main.dart';

abstract class SizedObject extends Drawable {
  var flexSize = FlexSize(virtual: Size(100, 100));

  SizedObject(GraphKernel kernel) : super(kernel);
}
