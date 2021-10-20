import 'dart:ui';

import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

enum HorizontalAlignment { left, right }

class AlignDrawZone extends Viewable with SinglePropagator {
  final GraphObject? child;
  final HorizontalAlignment alignement;
  late final DrawZone zone;

  AlignDrawZone({required this.alignement, this.child});

  void draw(covariant DrawEvent originalEvent) {
    super.draw(originalEvent as ViewEvent);
    final event = originalEvent.copy();
    zone = event.drawZone;
    updateZone();
    event.drawZone = zone;
    propagate(event);
  }

  void updateZone() {}
}
