import 'dart:ui';

import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/view.dart';

class ResizeDrawZone extends GraphObject with SinglePropagator {
  final GraphObject? child;
  final double? width;
  final double? height;
  late DrawZone zone;

  ResizeDrawZone({this.width, this.height, this.child}) {
    eventRegistry.add(DrawEvent, (e) => draw(e));
    eventRegistry.add(ViewEvent, (e) => draw(e));
  }

  void draw(DrawEvent originalEvent) {
    final event = originalEvent.copy();
    zone = event.drawZone;
    updateZone();
    propagate(event);
  }

  void updateZone() {
    updateHeight();
    updateWidth();
  }

  void updateHeight() {
    if (height == null) return;
    final zoneWidth = zone.size.width;
    zone.size = Size(zoneWidth, height!);
  }

  void updateWidth() {
    if (width == null) return;
    final zoneHeight = zone.size.height;
    zone.size = Size(width!, zoneHeight);
  }
}
