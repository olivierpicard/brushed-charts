import 'dart:async';

import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pipe/example/testEvent.dart';

class TesterSend extends GraphObject with SinglePropagator {
  final GraphObject child;
  TesterSend({required this.child}) {
    Init.child(this, child);
    propagateWithDelay();
  }

  void propagateWithDelay() {
    Timer(const Duration(seconds: 1), () {
      final event = TestEvent(name: "an event");
      propagate(event);
    });
  }
}
