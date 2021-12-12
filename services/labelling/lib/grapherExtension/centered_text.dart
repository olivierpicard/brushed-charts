import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';

class CenteredText extends Drawable with EndlinePropagator {
  final String text;
  CenteredText(this.text) {
    eventRegistry.add(ViewEvent, draw);
  }

  @override
  void draw(dynamic event) {
    event = event as DrawEvent;
    super.draw(event);
    _paintText();
  }

  void _paintText() {
    final canvas = baseDrawEvent!.canvas;
    final zoneSize = baseDrawEvent!.drawZone.size;
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((zoneSize.width - textPainter.width) / 2,
            (zoneSize.height - textPainter.height) / 2));
  }
}
