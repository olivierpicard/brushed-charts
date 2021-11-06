import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/axis/haxis.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class ReactiveHAxis extends HorizontalAxis with SinglePropagator {
  CellEvent? cellEvent;

  ReactiveHAxis({GraphObject? child}) : super(child: child) {
    eventRegistry.add(CellEvent, (e) => onCellEvent(e as CellEvent));
  }

  void onCellEvent(CellEvent event) {
    cellEvent = event;
    print("sdsd");
    setState(this);
  }

  void draw(DrawEvent event) {
    super.draw(event);
    if (cellEvent == null || cellEvent?.data == null) return;
    final tagRect = prepareCursorTag();
    final tagText = format(cellEvent!.datetime!);
    drawTagBackground(tagRect);
    drawTagText(tagRect, tagText);
  }

  Rect prepareCursorTag() {
    final axisZone = baseDrawEvent!.drawZone.toRect;
    final left = cellEvent!.drawZone.toRect.center.dx;
    final right = left + textWidth;
    final tagRect = Rect.fromLTRB(left, axisZone.top, right, axisZone.bottom);
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
    painter.paint(viewEvent!.canvas, Offset(tagRect.left, tagRect.top));
  }
}
