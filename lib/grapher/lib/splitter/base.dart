import '/kernel/drawEvent.dart';
import '/flex/object.dart';
import '/staticLayout/directional.dart';

import 'handle/base.dart';

mixin Splitter on DirectionalLayout {
  late double rawLength;

  double getZoneLength();
  Handle makeHandle(FlexObject previous, FlexObject next);

  void addHandles() {
    for (int i = 1; i < children.length; i += 2) {
      final previous = children[i - 1] as FlexObject;
      final current = children[i] as FlexObject;
      final handle = makeHandle(previous, current);
      children.insert(i, handle);
    }
  }

  @override
  void draw(covariant DrawEvent drawEvent) {
    preDraw(drawEvent);
    DrawEvent? lastEvent;
    for (final child in children as List<FlexObject>) {
      lastEvent = makeDrawEvent(lastEvent, child);
      child.handleEvent(lastEvent);
    }
  }

  void preDraw(DrawEvent drawEvent) {
    baseDrawEvent = drawEvent;
    updateRawLength();
  }

  void updateRawLength() {
    final baseLength = getZoneLength();
    final viewCount = _getViewCount();
    if (children.length <= 1)
      rawLength = baseLength;
    else
      rawLength = baseLength / viewCount;
  }

  int _getViewCount() {
    final childrenCount = children.length;
    final handleCount = (childrenCount / 2).truncate();
    final viewCount = childrenCount - handleCount;

    return viewCount;
  }

  @override
  double getChildLength(FlexObject child) {
    final bias = child.length.bias;
    if (child is Handle) return Handle.THICKNESS;
    if (child == children.first) return rawLength + bias;

    return getRegularLength(child);
  }

  double getRegularLength(FlexObject child) {
    final bias = child.length.bias;
    final netLength = rawLength - Handle.THICKNESS;
    final biasedLength = netLength + bias;

    return biasedLength;
  }
}
