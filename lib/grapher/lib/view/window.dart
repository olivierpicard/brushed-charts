import 'dart:collection';
import 'dart:ui';

import 'package:flutter/src/gestures/drag_details.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';

class Window extends Drawable with SinglePropagator, HitHelper, DragHelper {
  final baseChunkLength = 20;
  double scale = 1;
  double xOffset = 0;
  var sortedData = LinkedList<Data2D>();

  Window({GraphObject? child}) {
    Init.child(this, child);
    addEventListeners();
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
    if (sortedData.isEmpty) return;
    final upperBound = getUpperBound();
    final lowerBound = getLowerBound();
    if (isBoundsValid(lowerBound, upperBound)) {
      //TODO: Make a custom draw event and give the Data2D range
    }
  }

  int maxDisplayableData() {
    final zoneSize = baseDrawEvent!.drawZone.size;
    return (zoneSize.width / baseChunkLength).ceil();
  }

  int getUpperBound() {
    if (xOffset <= 0) return sortedData.length - 1;
    final skipCounter = (xOffset / baseChunkLength).floor();
    final upperBound = sortedData.length - skipCounter - 1;

    return upperBound;
  }

  int getLowerBound() {
    final upperBound = getUpperBound();
    var lowerBound = upperBound - maxDisplayableData();
    if (lowerBound <= 0) lowerBound = 0;

    return lowerBound;
  }

  bool isBoundsValid(int lowerBound, int upperBound) {
    if (upperBound <= lowerBound) return false;
    return true;
  }

  @override
  void onDrag(DragUpdateDetails event) {}
}
