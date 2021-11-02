import 'package:flutter/material.dart';
import 'package:grapher/axis/base.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class VerticalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '60px';
  static const double TEXT_HEIGHT = 70;
  final int maxDigit = 8;
  final int margin = 5;
  final double fontSize = 10;

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
      final formatedPrice = formatPrice(v, vRange.max);
      drawText(formatedPrice, p);
    }
  }

  String formatPrice(double rawPrice, double originalprice) {
    final strPrice = originalprice.toString();
    if (!strPrice.contains('.')) return rawPrice.toString();
    final intPartCount = int.parse(rawPrice.toString().split('.')[0]);
    final desiredDecimalLen = maxDigit - intPartCount;
    return rawPrice.toStringAsFixed(desiredDecimalLen);
  }

  void drawText(String text, double yPos) {
    final x = viewEvent!.drawZone.toRect.right;
    final span = TextSpan(
        text: text, style: TextStyle(color: Colors.white, fontSize: fontSize));
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(viewEvent!.canvas, Offset(x + margin, yPos));
  }
}
