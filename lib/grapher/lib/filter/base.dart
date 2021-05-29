import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'incoming-data.dart';

abstract class Filter extends GraphObject with SinglePropagator {
  Filter(GraphObject? child) {
    Init.child(this, child);
    eventRegistry.add(
        IncomingData, (event) => onIncomingData(event as IncomingData));
  }

  void onIncomingData(IncomingData input);
}
