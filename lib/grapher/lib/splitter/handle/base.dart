import '/flex/object.dart';
import 'package:flutter/material.dart';
import '/kernel/drawEvent.dart';
import '/kernel/propagator/endline.dart';
import '/pointer/helper/drag.dart';

abstract class Handle extends FlexObject with EndlinePropagator, DragHelper {
  static const double THICKNESS = 20;
  static const double CIRCLE_RADIUS = THICKNESS / 4;
  static const double CIRCLE_OFFSET = CIRCLE_RADIUS * 2 + 2;
  static const int _GREY = 200;
  static const COLOR = Color.fromRGBO(_GREY, _GREY, _GREY, 1.0);
  static const CIRCLE_COLOR = Colors.black38;

  final FlexObject previous, next;

  double getDeltaDrag(DragUpdateDetails event);
  double getObjectLength(FlexObject object);
  List<Offset> getCircleCenters(DrawEvent drawEvent);

  Handle(this.previous, this.next) {
    dragAddEventListeners();
  }

  @override
  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    _drawBackground(drawEvent);
    _drawCircle(drawEvent);
  }

  @override
  void onDrag(DragUpdateDetails event) {
    final deltaDrag = getDeltaDrag(event);
    if (!_isSizeCorrect(deltaDrag)) return;

    previous.length.bias += deltaDrag;
    next.length.bias -= deltaDrag;
    setState(this);
  }

  void _drawBackground(DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final paint = Paint()..color = COLOR;
    final background = getRect(drawEvent);
    canvas.drawRect(background, paint);
  }

  void _drawCircle(DrawEvent drawEvent) {
    final canvas = drawEvent.canvas;
    final centers = getCircleCenters(drawEvent);
    final paint = Paint()..color = CIRCLE_COLOR;
    canvas.drawCircle(centers[0], CIRCLE_RADIUS, paint);
    canvas.drawCircle(centers[1], CIRCLE_RADIUS, paint);
    canvas.drawCircle(centers[2], CIRCLE_RADIUS, paint);
  }

  bool _isSizeCorrect(double deltaDrag) {
    if (_isObjectSizeOK(previous, deltaDrag) &&
        _isObjectSizeOK(next, -deltaDrag)) {
      return true;
    }
    return false;
  }

  bool _isObjectSizeOK(FlexObject object, double deltaDrag) {
    if (object.baseDrawEvent == null) return true;
    final length = getObjectLength(object);
    if (length + deltaDrag > 0) return true;

    return false;
  }

  Offset getPosition(DrawEvent event) => event.drawZone.position;
  Size getSize(DrawEvent event) => event.drawZone.size;
  Rect getRect(DrawEvent event) => getPosition(event) & getSize(event);
  Offset getCenter(DrawEvent event) => getRect(event).center;
}
