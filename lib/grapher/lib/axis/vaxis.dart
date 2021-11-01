import 'package:flutter/material.dart';
import 'package:grapher/axis/base.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';

class VerticalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '40px';
  static const double TEXT_HEIGHT = 35;
  VerticalAxis({GraphObject? child}) : super(child);

  @override
  void onViewEvent(ViewEvent event) {
    super.onViewEvent(event);
    final range = event.yAxis.virtualRange;
    final text_count = event.yAxis.pixelRange.length / TEXT_HEIGHT;
    final vincrement_rate = range.length / text_count;
    drawAxis(vincrement_rate);
  }

  void drawAxis(double vincrement_rate) {
    final vRange = viewEvent!.yAxis.virtualRange;
    final pRange = viewEvent!.yAxis.pixelRange;
    for (double v = vRange.min, p = pRange.max;
        p > pRange.min;
        v += vincrement_rate, p -= TEXT_HEIGHT) {
      drawText(v.toString(), p);
    }
  }

  void drawText(String text, double yPos) {
    final x = viewEvent!.drawZone.toRect.right;
    final span = TextSpan(text: text, style: TextStyle(color: Colors.white));
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    painter.layout();
    print(x);
    //TODO: Draw the text above the background
    painter.paint(viewEvent!.canvas, Offset(x - 53, yPos));
  }
}
