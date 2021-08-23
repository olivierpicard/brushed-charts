import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/drawUnit/metadata.dart';

class CanvasTransform {
  final DrawUnit unit;
  final DrawUnitMetadata metadata;
  CanvasTransform(this.unit) : metadata = unit.metadata {}

  static void start(DrawUnit unit) {
    CanvasTransform(unit).startTransform();
  }

  static void end(DrawUnit unit) {
    CanvasTransform(unit).endTransform();
  }

  void startTransform() {
    final canvas = metadata.viewEvent.canvas;
    canvas.save();
    transformCanvas();
  }

  void endTransform() {
    final canvas = metadata.viewEvent.canvas;
    canvas.restore();
  }

  void transformCanvas() {
    moveToUnitPosition();
    removeYGap();
    centerChild();
    scaleCanvas();
  }

  void removeYGap() {
    final canvas = metadata.viewEvent.canvas;
    final gapLength = gapLengthBellowData();
    canvas.translate(0, gapLength);
  }

  void moveToUnitPosition() {
    final canvas = metadata.viewEvent.canvas;
    final unitPosition = metadata.viewEvent.drawZone.position;
    canvas.translate(unitPosition.dx, 0);
  }

  double gapLengthBellowData() {
    final unitPosition = metadata.viewEvent.drawZone.position;
    final scaleFactor = metadata.yAxis.scale;
    final lowerYPoint = metadata.yAxis.min * scaleFactor;
    final zoneHeight = metadata.viewEvent.drawZone.size.height;
    final yGapDeletion = unitPosition.dy + lowerYPoint + zoneHeight;

    return yGapDeletion;
  }

  void centerChild() {
    final canvas = metadata.viewEvent.canvas;
    canvas.translate(childXCenter(), 0);
  }

  double childXCenter() {
    final childWidth = unit.calculateChildWidth();
    final unitCenter = metadata.viewEvent.drawZone.size.width / 2;
    final startPosition = unitCenter - childWidth / 2;

    return startPosition;
  }

  void scaleCanvas() {
    final canvas = metadata.viewEvent.canvas;
    final scaleFactor = metadata.yAxis.scale;

    canvas.scale(1, -scaleFactor);
  }
}
