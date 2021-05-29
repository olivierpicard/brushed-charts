import '/flex/object.dart';
import '/kernel/propagator/multi.dart';
import '/splitter/base.dart';
import '/staticLayout/vertical.dart';

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
