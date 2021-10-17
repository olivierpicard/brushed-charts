import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/helper/child-event.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

import 'metadata.dart';

class DrawUnit extends Viewable with SinglePropagator {
  final DrawUnitObject child;
  late final DrawUnitMetadata metadata;

  DrawUnit.template({required this.child});

  DrawUnit(this.metadata, DrawUnitObject template)
      : child = template.instanciate() {
    Init.child(this, child);
  }

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final childEvent = ChildUnitEvent.make(this);
    if (childEvent == null) return;
    propagate(childEvent);
  }

  DrawUnit instanciate(DrawUnitMetadata metadata) {
    return DrawUnit(metadata, child);
  }
}
