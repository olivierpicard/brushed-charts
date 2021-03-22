import 'package:flex/object.dart';
import 'package:kernel/propagator/multi.dart';
import 'package:splitter/base.dart';
import 'package:splitter/handle/horizontal.dart';
import 'package:staticLayout/horizontal.dart';

import 'handle/base.dart';

class HorizontalSplitter extends HorizontalLayout
    with MultiPropagator, Splitter {
  HorizontalSplitter({required List<FlexObject> children})
      : super(children: children) {
    addHandles();
  }

  @override
  double getZoneLength() => baseDrawEvent!.drawZone.size.width;

  Handle makeHandle(FlexObject previous, FlexObject next) {
    return HorizontalHandle(previous, next);
  }
}
