import '/flex/object.dart';
import '/kernel/propagator/multi.dart';
import '/splitter/base.dart';
import '/splitter/handle/horizontal.dart';
import '/staticLayout/horizontal.dart';

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
