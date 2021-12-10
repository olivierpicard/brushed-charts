import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pipe/pipeEvent.dart';

class PipeIn extends GraphObject with SinglePropagator {
  final String name;
  final Type eventType;
  final GraphObject? child;
  PipeIn({required this.name, required this.eventType, this.child}) {
    Init.child(this, child);
    eventRegistry.add(eventType, onIncomingEvent);
  }

  void onIncomingEvent(dynamic inputEvent) {
    final pipeEvent = makeEvent(inputEvent);
    kernel!.handleEvent(pipeEvent);
  }

  PipeEvent makeEvent(dynamic inputEvent) => PipeEvent(name, inputEvent);
}
