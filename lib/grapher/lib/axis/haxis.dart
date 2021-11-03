import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grapher/axis/base.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';

class HorizontalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '30px';
  final margin = 50;
  final textWidth = 150;

  HorizontalAxis({GraphObject? child}) : super(child);

  @override
  void draw(DrawEvent event) {
    super.draw(event);
    drawAxis();
  }

  void drawAxis() {
    final dateRange = makeDateRange();
    final pRange = viewEvent!.xAxis.pixelRange;
    final incrementRate = getTimestampIncrementRate(dateRange);
    for (double d = dateRange.min, p = pRange.min;
        p < pRange.max;
        d += incrementRate, p += textWidth) {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch((d as int), isUtc: true);
      final formatedDate = dateTime.toIso8601String();
      drawText(formatedDate, p);
    }
  }

  void drawText(String text, double xPos) {
    final y = viewEvent!.drawZone.toRect.bottom;
    final span = TextSpan(
        text: text, style: TextStyle(color: Colors.white, fontSize: fontSize));
    final painter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(viewEvent!.canvas, Offset(xPos, y));
  }

  int getTimestampIncrementRate(Range dateRange) {
    final labelCount = (viewEvent!.xAxis.pixelRange.length as int) / textWidth;
    final timestampIncrement = dateRange.length.toInt() / labelCount;
    return timestampIncrement.toInt();
  }

  Range makeDateRange() {
    final first = (viewEvent!.chainData.first as Timeseries2D).timestamp;
    final last = (viewEvent!.chainData.first as Timeseries2D).timestamp;
    final dateRange = Range(first, last);
    return dateRange;
  }
}
