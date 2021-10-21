import 'package:grapher/detachedPanel/resize.dart';
import 'package:grapher/detachedPanel/vertical-align.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/y-pixel-range.dart';
import 'package:grapher/view/view-event.dart';

import 'align-options.dart';
import 'horizontal-align.dart';

class DetachedPanel extends GraphObject with SinglePropagator {
  final GraphObject? child;
  final double? width, height;
  final HAlign? hAlignment;
  final VAlign? vAlignment;
  final double hBias, vBias;
  late DrawZone originalZone, newZone;
  late DrawEvent newEvent;

  DetachedPanel(
      {this.width,
      this.height,
      this.hAlignment,
      this.vAlignment,
      this.hBias = 0,
      this.vBias = 0,
      GraphObject? child})
      : child = YPixelRangeUpdate(child: child) {
    eventRegistry.add(DrawEvent, (e) => draw(e));
    eventRegistry.add(ViewEvent, (e) => draw(e));
  }

  void draw(DrawEvent event) {
    initZone(event);
    updateSize();
    updatePosition();
    propagate(newEvent);
  }

  void initZone(DrawEvent event) {
    originalZone = event.drawZone;
    newEvent = event.copy();
    newZone = newEvent.drawZone;
  }

  void updateSize() {
    ResizeDrawZone(newZone, width, height);
  }

  void updatePosition() {
    HAlignDrawZone(originalZone, newZone, hAlignment, hBias);
    VAlignDrawZone(originalZone, newZone, vAlignment, vBias);
  }
}
