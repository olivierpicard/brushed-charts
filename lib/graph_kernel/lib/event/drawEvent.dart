import 'package:flutter/widgets.dart';

import '../cursor.dart';
import 'sceneEvent.dart';

class DrawEvent extends SceneEvent {
  static const String id = "draw";
  final Cursor cursor;
  final Canvas canvas;

  DrawEvent(this.cursor, this.canvas);

  @override
  String getID() => id;
}
