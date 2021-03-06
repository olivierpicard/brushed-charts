import 'dart:ui';

import 'package:kernel/cursor.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/sizedObject.dart';
import 'package:staticLayout/layout.dart';

class VAlign extends Layout {
  VAlign(GraphKernel kernel) : super(kernel);

  @override
  void draw(covariant DrawEvent drawEvent) {
    final children = this.children as List<SizedObject>;
    for (final child in children) {}
  }
}
