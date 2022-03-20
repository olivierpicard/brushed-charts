import 'package:flutter/material.dart';
import 'package:grapher/cell/cell.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/cell/pointer-summary.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/line.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class HairCross extends Viewable with SinglePropagator {
  final Paint paint;
  GraphObject? child;
  Offset? position;
  Cell? cell;

  HairCross({Paint? paint, this.child})
      : this.paint = paint ?? (Paint()..color = Color(0x50ffffff)) {
    eventRegistry.add(CellEvent, (e) => onCellEvent(e as CellEvent));
  }

  @override
  void draw(ViewEvent event) {
    super.draw(event);
    if (position == null) return;
    final hLine = makeHorizontalLine();
    final vLine = makeVerticalLine();
    paintCrossHair(hLine, vLine);
  }

  void onCellEvent(CellEvent event) {
    if (event.pointer.type != PointerType.Hover) return;
    final drawZone = event.cell.baseDrawEvent?.drawZone;
    if (drawZone == null) return;
    final x = drawZone.toRect.center.dx;
    final pixelY = event.viewEvent.yAxis.toPixel(event.virtualY);
    position = Offset(x, pixelY);
    setState(this);
  }

  Line makeHorizontalLine() {
    final left = baseDrawEvent!.drawZone.toRect.left;
    final right = baseDrawEvent!.drawZone.toRect.right;
    final p1 = Offset(left, position!.dy);
    final p2 = Offset(right, position!.dy);
    return Line(p1, p2);
  }

  Line makeVerticalLine() {
    final top = baseDrawEvent!.drawZone.toRect.top;
    final bottom = baseDrawEvent!.drawZone.toRect.bottom;
    final p1 = Offset(position!.dx, top);
    final p2 = Offset(position!.dx, bottom);
    return Line(p1, p2);
  }

  void paintCrossHair(Line hline, Line vline) {
    canvas!.drawLine(hline.p1, hline.p2, paint);
    canvas!.drawLine(vline.p1, vline.p2, paint);
  }
}
