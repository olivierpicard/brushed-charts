import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/drawUnit/draw-unit-object.dart';
import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/pointer/helper/hit.dart';
import 'package:grapher/pointer/helper/hover.dart';
import '../drawUnit/metadata.dart';

class Cell extends DrawUnit with HitHelper, HoverHelper {
  Cell(DrawUnitMetadata metadata, DrawUnitObject template)
      : super(metadata, template) {
    hitAddEventListeners();
    hoverAddEventListeners();
  }

  Cell.template({required DrawUnitObject template})
      : super.template(child: template);

  Cell instanciate(DrawUnitMetadata metadata) {
    return Cell(metadata, child);
  }

  @override
  void onHover(PointerHoverEvent event) {
    if (!isTappingOnSelf(event.position)) return;
    final cellEvent = CellEvent(this, event, null);
    propagate(cellEvent);
  }

  @override
  void onTapDown(covariant TapDownDetails event) {
    if (!isTappingOnSelf(event.globalPosition)) return;
    final hitObject = getHitChild(event.globalPosition);
    final cellEvent = CellEvent(this, event, hitObject);
    propagate(cellEvent);
  }

  bool isTappingOnSelf(Offset position) {
    if (baseDrawEvent == null) return false;
    if (!isHit(position)) return false;
    return true;
  }

  DrawUnitObject? getHitChild(Offset position) {
    if (child.isHit(position)) return child;
    return null;
  }
}
