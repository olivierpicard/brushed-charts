import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/scroll.dart';
import 'package:grapher/view/view.dart';

abstract class InteractiveView extends View with DragHelper, ScrollHelper {
  InteractiveView({
    double unitLength = View.DEFAULT_UNIT_LENGTH,
    GraphObject? child,
  }) : super(unitLength: unitLength, child: child);

  @override
  void initEventListener() {
    super.initEventListener();
    dragAddEventListeners();
    scrollAddEventListeners();
  }

  @override
  void onDrag(DragUpdateDetails event) {
    if (!isPointerOnView(event.localPosition)) return;
    xAxis.offset += event.delta.dx;
    yAxis.offset += event.delta.dy;
    setState(this);
  }

  @override
  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    final yScrollDelta = getSpreadZoom(event.scrollDelta.dy);
    xAxis.zoom += yScrollDelta;
    setState(this);
  }

  bool isPointerOnView(Offset pointerPosition) {
    if (super.baseDrawEvent == null) return false;
    final drawRect = super.baseDrawEvent!.drawZone.toRect;
    return drawRect.contains(pointerPosition);
  }

  double getSpreadZoom(double deltaScroll) {
    if (baseDrawEvent == null) return 0;
    final zoneWidth = baseDrawEvent!.drawZone.size.width;
    final unitCount = zoneWidth / xAxis.unitLength;
    final moderatedScroll = deltaScroll / unitCount;
    return moderatedScroll;
  }
}
