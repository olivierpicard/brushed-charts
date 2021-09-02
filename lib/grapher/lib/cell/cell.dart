import 'package:flutter/material.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/pointer/helper/hit.dart';
import '../drawUnit/metadata.dart';

class Cell extends DrawUnit with HitHelper {
  Cell(DrawUnitMetadata metadata, DrawUnitObject template)
      : super(metadata, template) {
    hitAddEventListeners();
  }

  Cell.template({required DrawUnitObject child}) : super.template(child: child);

  Cell instanciate(DrawUnitMetadata metadata) {
    return Cell(metadata, child);
  }

  @override
  void onTapDown(covariant TapDownDetails event) {
    if (!isTappingOnSelf(event)) return;
    final cellEvent = CellEvent(this, event);
    propagate(cellEvent);
  }

  bool isTappingOnSelf(TapDownDetails tap) {
    if (baseDrawEvent == null) return false;
    if (!isHit(tap.globalPosition)) return false;
    return true;
  }
}
