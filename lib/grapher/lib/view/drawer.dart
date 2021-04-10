import 'dart:collection';

import 'package:grapher/geometry/geometry.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/model/data2D.dart';
import 'package:grapher/model/event/incoming-data.dart';
import 'package:grapher/geometry/draw-unit-event.dart';

class Drawer extends Drawable with SinglePropagator {
  static const UNIT_LENGTH = 10.0;
  final GeometryInstanciator geometryFactory;
  final geometrics = <Geometry>[];
  double xCursor = 0;

  Drawer({required this.geometryFactory, GraphObject? child}) {
    Init.child(this, child);
    eventRegistry.add(
        IncomingData, (event) => onModelEvent(event as IncomingData));
  }

  void onModelEvent(IncomingData event) {
    if (event.content is! LinkedList<Data2D>) return;
    final data = event.content as LinkedList<Data2D>;
    Data2D? latest = data.last;
    while (latest != null) {
      geometrics.add(geometryFactory(latest));
      latest = latest.previous;
    }
    setState(this);
  }

  @override
  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    xCursor = 0;
    for (final geometric in geometrics) {
      final unitEvent = makeDrawUnitEvent();
      xCursor += UNIT_LENGTH;
      geometric.draw(unitEvent);
    }
  }

  DrawUnitEvent makeDrawUnitEvent() {
    return DrawUnitEvent(
        drawEvent: baseDrawEvent!, length: UNIT_LENGTH, cursor: xCursor);
  }

  // @override
  // void propagate(event) {}
}
