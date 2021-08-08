import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/drawUnit/factory.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/view/view-event.dart';

import '../metadata.dart';
import 'drawzone.dart';
import 'yScale.dart';

class MetadataHelper {
  final DrawUnitFactory fact;
  late final DrawUnitMetadata metadata;

  MetadataHelper(this.fact, Data2D item) {
    final yScale = YScaleHelper.calculate(fact);
    final newViewEvent = updateViewEvent();
    final previous = getPrevious();
    metadata = DrawUnitMetadata(newViewEvent, yScale, item, previous);
  }

  static DrawUnitMetadata make(DrawUnitFactory fact, Data2D item) {
    return MetadataHelper(fact, item).metadata;
  }

  ViewEvent updateViewEvent() {
    final drawZone = DrawZoneHelper.getUpdate(fact);
    final drawEvent = DrawEvent.fromUpdatedDrawZone(fact.viewEvent, drawZone);
    final viewAxis = fact.viewEvent.viewAxis;
    final data = fact.viewEvent.chainData;
    final newViewEvent = ViewEvent.fromDrawEvent(drawEvent, viewAxis, data);

    return newViewEvent;
  }

  DrawUnit? getPrevious() {
    if (fact.children.length == 0) return null;
    final previousChunk = fact.children.last as DrawUnit;

    return previousChunk;
  }
}
