import 'package:flutter/material.dart';
import 'package:grapher/axis/base.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';

class HorizontalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '35px';
  final topMargin = 2;
  final double occupiedSpace = 170;

  HorizontalAxis({GraphObject? child}) : super(child);

  @override
  void draw(DrawEvent event) {
    super.draw(event);
    if (viewEvent == null) return;
    drawAxis();
  }

  void drawAxis() {
    final dateRange = makeDateRange();
    final pRange = viewEvent!.xAxis.pixelRange;
    final incrementRate = getTimestampIncrementRate(dateRange);
    for (double d = dateRange.min, p = pRange.min;
        p < pRange.max;
        d += incrementRate, p += occupiedSpace) {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        d.round(),
        isUtc: true,
      );
      final formattedDate = this.format(dt);
      drawText(formattedDate, p);
    }
  }

  Range makeDateRange() {
    final first = (viewEvent!.chainData.first as Timeseries2D).timestamp;
    final last = (viewEvent!.chainData.last as Timeseries2D).timestamp;
    final dateRange = Range(first, last);
    return dateRange;
  }

  int getTimestampIncrementRate(Range dateRange) {
    final labelCount = viewEvent!.xAxis.pixelRange.length / occupiedSpace;
    final timestampIncrement = dateRange.length / labelCount;
    return timestampIncrement.round();
  }

  String format(DateTime dt) {
    final strDate = dt.toIso8601String();
    final multiline = strDate.replaceAll('T', '\n');
    final withoutFraction = multiline.split('.')[0];
    return withoutFraction;
  }

  void drawText(String text, double xPos) {
    final y = viewEvent!.drawZone.toRect.bottom + topMargin;
    final span = TextSpan(
        text: text, style: TextStyle(color: Colors.white, fontSize: fontSize));
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    painter.layout(
        minWidth: occupiedSpace.toDouble(), maxWidth: occupiedSpace.toDouble());
    painter.paint(viewEvent!.canvas, Offset(xPos, y));
  }
}
