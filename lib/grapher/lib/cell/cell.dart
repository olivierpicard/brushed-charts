import 'package:flutter/material.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/view/view-event.dart';
import '../drawUnit/metadata.dart';

class Cell extends DrawUnit with HitHelper, DragHelper {
  Cell(DrawUnitMetadata metadata, DrawUnitObject template)
      : super(metadata, template) {
    hitAddEventListeners();
    dragAddEventListeners();
  }

  Cell.template({required DrawUnitObject child}) : super.template(child: child);

  Cell instanciate(DrawUnitMetadata metadata) {
    return Cell(metadata, child);
  }

  void draw(covariant ViewEvent event) {
    super.draw(event);
  }

  @override
  void onTapDown(covariant TapDownDetails event) {
    print(baseDrawEvent?.drawZone);
    if (isHit(event.localPosition)) {
      print("sss");
    }
    // print(event.globalPosition);
  }

  @override
  void onDrag(DragUpdateDetails event) {
    // print(event.delta);
  }
}
