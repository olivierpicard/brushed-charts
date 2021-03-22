import 'package:flex/object.dart';
import 'package:kernel/propagator/multi.dart';
import 'package:splitter/base.dart';
import 'package:staticLayout/vertical.dart';

import 'handle/base.dart';
import 'handle/vertical.dart';

class VerticalSplitter extends VerticalLayout with MultiPropagator, Splitter {
  VerticalSplitter({required List<FlexObject> children})
      : super(children: children) {
    addHandles();
  }

  @override
  double getZoneLength() => baseDrawEvent!.drawZone.size.height;

  Handle makeHandle(FlexObject previous, FlexObject next) {
    return VerticalHandle(previous, next);
  }
}
