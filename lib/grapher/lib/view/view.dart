import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-axis.dart';
import 'package:grapher/view/view-event.dart';

class View extends Drawable with SinglePropagator {
  static const double DEFAULT_CHUNK_LENGTH = 20;
  Iterable<Data2D>? inputData;
  ViewAxis viewAxis;

  View({
    double chunkLength = View.DEFAULT_CHUNK_LENGTH,
    GraphObject? child,
  }) : viewAxis = ViewAxis(baseChunkLength: chunkLength) {
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

  @override
  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    final viewEvent = ViewEvent(drawEvent, viewAxis, inputData);
    propagate(viewEvent);
  }
}
