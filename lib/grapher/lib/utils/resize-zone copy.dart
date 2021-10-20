import 'dart:ui';

import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';

enum HorizontalAlignment { left, right }
enum VerticalAlignment { top, bottom }

class AlignDrawZone extends GraphObject with SinglePropagator {
  final GraphObject? child;
  final HorizontalAlignment? hAlignement;
  final VerticalAlignment? vAlignement;
  late final DrawZone zone;

  AlignDrawZone({this.hAlignement, this.vAlignement, this.child}) {
    eventRegistry.add(DrawEvent, (e) => draw(e));
    eventRegistry.add(ViewEvent, (e) => draw(e));
  }

  void draw(DrawEvent originalEvent) {
    final event = originalEvent.copy();
    zone = event.drawZone;
    updateZone();
    propagate(event);
  }

  void updateZone() {}
}
