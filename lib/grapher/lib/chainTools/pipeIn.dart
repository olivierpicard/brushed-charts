import 'package:grapher/chainTools/pipeEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';

class PipeIn extends GraphObject with EndlinePropagator {
  final String name;
  PipeIn({required this.name});

  @override
  void handleEvent(dynamic inputEvent) {
    if (inputIsSelf(inputEvent)) return;
    final pipeEvent = makeEvent(inputEvent);
    kernel!.propagate(pipeEvent);
  }

  bool inputIsSelf(inputEvent) {
    if (inputEvent is! PipeEvent) return false;
    if (inputEvent.name != this.name) return false;

    return true;
  }

  PipeEvent makeEvent(dynamic inputEvent) => PipeEvent(name, inputEvent);
}
