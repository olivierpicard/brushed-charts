import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/y-virtual-range.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';

class View extends Drawable with SinglePropagator {
  static const double DEFAULT_UNIT_LENGTH = 20;
  Iterable<Data2D>? inputData;
  final xAxis = UnitAxis();
  final yAxis = VirtualAxis();

  View({double unitLength = View.DEFAULT_UNIT_LENGTH, GraphObject? child}) {
    xAxis.unitLength = unitLength;
    Init.child(this, child);
    initEventListener();
  }

  void initEventListener() {
    eventRegistry.add(IncomingData, (e) {
      onIncomingData(e as IncomingData);
    });
  }

  void draw(DrawEvent event) {
    super.draw(event);
    xAxis.pixelRange = event.drawZone.xRange;
    yAxis.pixelRange = event.drawZone.yRange;
  }

  void onIncomingData(IncomingData event) {
    if (event.content is! Iterable<Data2D?>) return;
    inputData = event.content;
    yAxis.virtualRange = YVirtualRangeUpdate.process(inputData!);
    setState(this);
  }

  bool isInputValid() {
    if (inputData == null) return false;
    if (inputData!.length == 0) return false;

    return true;
  }

  int maxDisplayableUnit() {
    final zoneSize = baseDrawEvent!.drawZone.size;
    final unitLength = xAxis.unitLength;
    final maxChunk = (zoneSize.width / unitLength).ceil();

    return maxChunk;
  }
}
