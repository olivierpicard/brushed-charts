import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class CenteredText extends Drawable with EndlinePropagator {
  final String text;
  CenteredText(this.text);

  void draw(DrawEvent event) {
    super.draw(event);
    _paintText();
  }

  void _paintText() {
    final canvas = baseDrawEvent!.canvas;
    final zoneSize = baseDrawEvent!.drawZone.size;
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(color: Colors.white)),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((zoneSize.width - textPainter.width) / 2,
            (zoneSize.height - textPainter.height) / 2));
  }
}
