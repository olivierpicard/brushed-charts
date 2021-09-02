import 'package:flutter/rendering.dart';
import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/pointer/helper/scroll.dart';
import 'package:grapher/view/view.dart';

abstract class InteractiveView extends View
    with HitHelper, DragHelper, ScrollHelper {
  InteractiveView({
    double unitLength = View.DEFAULT_CHUNK_LENGTH,
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
    final newOffset = viewAxis.offset + event.delta;
    viewAxis.offset = newOffset;
    setState(this);
  }

  @override
  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    final yScrollDelta = moderatedScroll(event.scrollDelta.dy);
    final zoom = viewAxis.zoom;
    final newScale = Offset(zoom.dx + yScrollDelta, zoom.dy);
    viewAxis.zoom = newScale;
    setState(this);
  }

  bool isPointerOnView(Offset pointerPosition) {
    if (super.baseDrawEvent == null) return false;
    final drawRect = super.baseDrawEvent!.drawZone.toRect;

    return drawRect.contains(pointerPosition);
  }

  double moderatedScroll(double deltaScroll) {
    if (baseDrawEvent == null) return 0;
    final zoneWidth = baseDrawEvent!.drawZone.size.width;
    final unitLen = viewAxis.unitLength;
    final unitCount = zoneWidth / unitLen;
    final moderatedScroll = deltaScroll / unitCount;

    return moderatedScroll;
  }
}
