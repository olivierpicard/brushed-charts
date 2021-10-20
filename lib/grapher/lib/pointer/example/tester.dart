import 'package:flutter/gestures.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/pointer/helper/hover.dart';
import 'package:grapher/pointer/helper/scroll.dart';

class Tester extends Drawable
    with EndlinePropagator, HitHelper, DragHelper, ScrollHelper, HoverHelper {
  Tester() {
    scrollAddEventListeners();
    dragAddEventListeners();
    hitAddEventListeners();
    hoverAddEventListeners();
  }

  @override
  void onHover(PointerHoverEvent event) {
    print('onHover --- position: ${event.position} ; delta: ${event.delta}');
  }

  @override
  void onDrag(DragUpdateDetails event) {
    print(
        'onDrag --- position: ${event.globalPosition} ; delta: ${event.delta}');
  }

  @override
  void onScroll(PointerScrollEvent event) {
    print('onScroll --- position: ${event.position} ; delta: ${event.delta}');
  }

  @override
  void onTapDown(TapDownDetails event) {
    print('onTap --- position: ${event.globalPosition}');
  }
}
