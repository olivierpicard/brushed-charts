import 'dart:collection';

import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/pointer/helper/scroll.dart';

import 'bound-process.dart';

class Window extends Drawable
    with SinglePropagator, HitHelper, DragHelper, ScrollHelper {
  final baseChunkLength = 20;
  double scale = 1;
  double xOffset = 0;
  var sortedData = LinkedList<Data2D>();

  Window({GraphObject? child}) {
    Init.child(this, child);
    dragAddEventListeners();
    scrollAddEventListeners();
    eventRegistry.add(
        IncomingData, (input) => onIncomingData(input as IncomingData));
  }

  void onIncomingData(IncomingData input) {
    if (input.content is! LinkedList<Data2D>) return;
    this.sortedData = input.content as LinkedList<Data2D>;
  }

  @override
  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    final bound = Bound(this);
    if (!bound.isValid()) return;
    final iterables = makeIterator(bound);
    propagate(IncomingData(iterables));
  }

  Iterable<Data2D> makeIterator(Bound bound) =>
      sortedData.skip(bound.lower).take(bound.upper);

  @override
  void onDrag(DragUpdateDetails event) {
    this.xOffset += event.delta.dx;
    setState(this);
  }

  @override
  void onScroll(PointerScrollEvent event) {
    print(event.scrollDelta);
    setState(this);
  }
}
