import 'dart:ui';

import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class ResizeDrawZone extends Viewable with SinglePropagator {
  final GraphObject? child;
  final double? width;
  final double? height;
  late final DrawZone zone;

  ResizeDrawZone({this.width, this.height, this.child}) {
    eventRegistry.add(DrawEvent, (e) => draw(e));
  }

  void draw(DrawEvent originalEvent) {
    super.draw(originalEvent as ViewEvent);
    final event = originalEvent.copy();
    zone = event.drawZone;
    updateZone();
    event.drawZone = zone;
    propagate(event as ViewEvent);
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