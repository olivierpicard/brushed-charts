import 'dart:ui';
import 'package:grapher/kernel/drawZone.dart';
import 'factory.dart';

class DrawZoneHelper {
  final DrawUnitFactory facto;
  late final DrawZone drawZone;

  DrawZoneHelper(this.facto) {
    final position = _computePosition();
    final size = _computeSize();
    drawZone = DrawZone(position, size);
  }

  static DrawZone getUpdate(DrawUnitFactory facto) {
    return DrawZoneHelper(facto).drawZone;
  }

  Offset _computePosition() {
    final start = _computeStartPoint();
    final base = facto.baseDrawEvent!.drawZone;
    final x = base.position.dx + start;
    final y = base.position.dy;
    final position = Offset(x, y);
    return position;
  }

  double _computeStartPoint() {
    final screenWidth = facto.viewEvent.drawZone.size.width;
    final chunkCount = facto.children.length;
    final chunkLength = facto.viewEvent.xAxis.unitLength;
    final start = screenWidth - chunkLength - chunkLength * chunkCount;
    return start;
  }

  Size _computeSize() {
    final unitLength = facto.viewEvent.xAxis.unitLength;
    final baseHeight = facto.baseDrawEvent!.drawZone.size.height;
    final size = Size(unitLength, baseHeight);
    return size;
  }
}
