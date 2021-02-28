import 'package:flutter/widgets.dart';
import 'cursor.dart';

class DrawEvent {
  final Cursor cursor;
  final Canvas canvas;

  DrawEvent(this.cursor, this.canvas);
}
