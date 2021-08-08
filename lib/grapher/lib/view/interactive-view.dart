import 'package:flutter/rendering.dart';
import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/pointer/helper/scroll.dart';
import 'package:grapher/view/view.dart';

class InteractiveView extends View with HitHelper, DragHelper, ScrollHelper {
  InteractiveView({
    double chunkLength = View.DEFAULT_CHUNK_LENGTH,
    GraphObject? child,
  }) : super(chunkLength: chunkLength, child: child);

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
    viewAxis = viewAxis.setOffset(newOffset);
    setState(this);
  }

  @override
  void onScroll(PointerScrollEvent event) {
    if (!isPointerOnView(event.localPosition)) return;
    final newScale =
        Offset(viewAxis.zoom.dx + event.scrollDelta.dy, viewAxis.zoom.dy);
    viewAxis = viewAxis.setScale(newScale);
    setState(this);
  }

  bool isPointerOnView(Offset pointerPosition) {
    if (super.baseDrawEvent == null) return false;
    final drawRect = super.baseDrawEvent!.drawZone.toRect;

    return drawRect.contains(pointerPosition);
  }
}