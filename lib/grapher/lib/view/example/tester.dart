import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(ViewEvent, (event) => onViewEvent(event as ViewEvent));
  }

  void onViewEvent(ViewEvent input) {
    print('''baseChunk: ${input.viewAxis.baseChunkLength}\n
chunkLength: ${input.viewAxis.chunkLength}\n
scale: ${input.viewAxis.lengthOffset}\n
offset: ${input.viewAxis.offset}\n
dataCount: ${input.data?.length}\n
----------\n''');
  }
}
