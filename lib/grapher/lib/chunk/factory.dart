import 'package:grapher/chunk/chunk.dart';
import 'package:grapher/chunk/metadata-maker.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class ChunkFactory extends Viewable with MultiPropagator {
  List<GraphObject> children = [];
  late ViewEvent viewEvent;

  ChunkFactory() {}

  @override
  void onView(ViewEvent event) {
    super.onView(event);
    viewEvent = event;
    instanciate();
    Init.children(this, children);
  }

  void instanciate() {
    children = [];
    viewEvent.data.forEach((item) {
      final metadataMaker = MetadataMaker(this);
      final previous = getPrevious();
      final metadata = metadataMaker.make();
      final chunk = Chunk(item, metadata, previous);
      children.add(chunk);
    });
  }

  Chunk? getPrevious() {
    if (children.length == 0) return null;
    final previousChunk = children.last as Chunk;

    return previousChunk;
  }
}
