import 'dart:ui';

import 'package:grapher/drawUnit/unit-drawable.dart';

mixin DrawUnitObject on UnitDrawable {
  double get widthPercent;
  DrawUnitObject instanciate();
  bool isHit(Offset hitPoint);
}
