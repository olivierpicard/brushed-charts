import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-axis.dart';

class View extends Drawable with SinglePropagator {
  static const double DEFAULT_CHUNK_LENGTH = 20;
  Iterable<Data2D>? inputData;
  ViewAxis viewAxis;

  View({
    double unitLength = View.DEFAULT_CHUNK_LENGTH,
    GraphObject? child,
  }) : viewAxis = ViewAxis(baseUnitLength: unitLength) {
    Init.child(this, child);
    initEventListener();
  }

  void initEventListener() {
    eventRegistry.add(IncomingData, (e) {
      onIncomingData(e as IncomingData);
    });
  }

  void onIncomingData(IncomingData event) {
    if (event.content is! Iterable<Data2D>) return;
    inputData = event.content;
    setState(this);
  }

  bool isInputValid() {
    if (inputData == null) return false;
    if (inputData!.length == 0) return false;

    return true;
  }

  int maxDisplayableUnit() {
    final zoneSize = baseDrawEvent!.drawZone.size;
    final unitLength = viewAxis.unitLength;
    final maxChunk = (zoneSize.width / unitLength).ceil();

    return maxChunk;
  }
}
