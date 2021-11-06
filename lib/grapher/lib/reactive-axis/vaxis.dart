import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/axis/haxis.dart';
import 'package:grapher/axis/vaxis.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class ReactiveVAxis extends VerticalAxis with SinglePropagator {
  CellEvent? cellEvent;

  ReactiveVAxis({GraphObject? child}) : super(child: child) {
    eventRegistry.add(CellEvent, (e) => onCellEvent(e as CellEvent));
  }

  void onCellEvent(CellEvent event) {
    cellEvent = event;
    setState(this);
  }

  void draw(DrawEvent event) {
    super.draw(event);
    if (cellEvent == null || cellEvent?.data == null) return;
    final tagRect = prepareCursorTag();
    final tagText = format(cellEvent!.virtualY);
    drawTagBackground(tagRect);
    drawTagText(tagRect, tagText);
  }

  Rect prepareCursorTag() {
    final axisZone = baseDrawEvent!.drawZone.toRect;
    final cursorY = cellEvent!.pointer.position.dy;
    final top = cursorY - VerticalAxis.TEXT_HEIGHT / 2;
    final bottom = cursorY + VerticalAxis.TEXT_HEIGHT / 2;
    final tagRect = Rect.fromLTRB(axisZone.left, top, axisZone.right, bottom);
    return tagRect;
  }

  void drawTagBackground(Rect tagRect) {
    final paint = Paint()..color = Colors.white;
    canvas!.drawRect(tagRect, paint);
  }

  void drawTagText(Rect tagRect, String tagText) {
    final style = TextStyle(color: Colors.black, fontSize: fontSize);
    final span = TextSpan(text: tagText, style: style);
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(viewEvent!.canvas, tagRect.topLeft);
  }
}
