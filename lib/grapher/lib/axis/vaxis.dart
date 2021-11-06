import 'package:flutter/material.dart';
import 'package:grapher/axis/base.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class VerticalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '80px';
  static const double TEXT_HEIGHT = 70;
  final int maxDigit = 8;

  VerticalAxis({GraphObject? child}) : super(child);

  @override
  void draw(DrawEvent event) {
    super.draw(event);
    if (viewEvent == null) return;
    final range = viewEvent!.yAxis.virtualRange;
    final text_count = viewEvent!.yAxis.pixelRange.length / TEXT_HEIGHT;
    final vincrement_rate = range.length / text_count;
    drawAxis(vincrement_rate);
  }

  void drawAxis(double vincrement_rate) {
    final vRange = viewEvent!.yAxis.virtualRange;
    final pRange = viewEvent!.yAxis.pixelRange;
    for (double v = vRange.min, p = pRange.max;
        p > pRange.min;
        v += vincrement_rate, p -= TEXT_HEIGHT) {
      final formatedPrice = format(v);
      drawText(formatedPrice, p);
    }
  }

  String format(double price) {
    final intPartStr = price.toString().split('.')[0];
    final intDigitCount = intPartStr.length;
    final maxDecimalDigit = maxDigit - intDigitCount;
    final fixedPriceLen = price.toStringAsFixed(maxDecimalDigit);
    return fixedPriceLen;
  }

  void drawText(String text, double yPos) {
    final x = viewEvent!.drawZone.toRect.right;
    final span = TextSpan(
        text: text, style: TextStyle(color: Colors.white, fontSize: fontSize));
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    painter.layout(minWidth: baseDrawEvent!.drawZone.size.width);
    painter.paint(viewEvent!.canvas, Offset(x, yPos));
  }
}
