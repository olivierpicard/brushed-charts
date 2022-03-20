import 'package:flutter/material.dart';
import 'package:grapher/axis/haxis.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class ReactiveHAxis extends HorizontalAxis with SinglePropagator {
  CellEvent? cellEvent;
  late final double cursorHeight = 10;
  final double tagBackgroundWidth = 150;

  ReactiveHAxis({GraphObject? child}) : super(child: child) {
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
    final tagText = formatSingleLine(cellEvent!.datetime!);
    drawTagBackground(tagRect);
    drawTagText(tagRect, tagText);
  }

  String formatSingleLine(DateTime dt) {
    final date = super.format(dt);
    final singleLine = date.replaceAll('\n', '   ');
    return singleLine;
  }

  Rect prepareCursorTag() {
    final axisZone = baseDrawEvent!.drawZone.toRect;
    final left = cellEvent!.drawZone.toRect.center.dx - tagBackgroundWidth / 2;
    final right = left + tagBackgroundWidth;
    final tagRect = Rect.fromLTRB(left, axisZone.top, right, axisZone.bottom);
    return tagRect;
  }

  void drawTagBackground(Rect tagRect) {
    final paint = Paint()..color = Colors.grey.shade800;
    canvas!.drawRect(tagRect, paint);
  }

  void drawTagText(Rect tagRect, String tagText) {
    final style = TextStyle(color: Colors.white, fontSize: fontSize, height: 2);
    final span = TextSpan(text: tagText, style: style);
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    painter.layout(minWidth: tagBackgroundWidth);
    painter.paint(viewEvent!.canvas, Offset(tagRect.left, tagRect.top));
  }
}
