import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pipe/pipeEvent.dart';

class PipeOut extends GraphObject with SinglePropagator {
  final String name;
  PipeOut({required this.name, required GraphObject child}) {
    Init.child(this, child);
    eventRegistry.add(PipeEvent, (e) => onPipeEvent(e as PipeEvent));
  }

  void onPipeEvent(PipeEvent event) {
    propagateIfNotConcerned(event);
    propagateIfPipeCorresponding(event);
  }

  void propagateIfNotConcerned(PipeEvent event) {
    if (event.name == this.name) return;
    propagate(event);
  }

  void propagateIfPipeCorresponding(PipeEvent event) {
    if (event.name != this.name) return;
    final unpackedEvent = event.content;
    propagate(unpackedEvent);
  }
}
