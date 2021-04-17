import 'package:grapher/kernel/drawEvent.dart';

class DrawUnitEvent extends DrawEvent {
  double length;
  double cursor;

  DrawUnitEvent({
    required DrawEvent drawEvent,
    required this.length,
    required this.cursor,
  }) : super(drawEvent.parent, drawEvent.canvas, drawEvent.drawZone);
}
