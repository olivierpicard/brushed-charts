import 'package:grapher/chunk/factory.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class ChunkFactoryTester extends Viewable with SinglePropagator {
  final ChunkFactory child;
  ChunkFactoryTester({required this.child});

  void onView(ViewEvent event) {
    propagate(event);
    print('Chunk count: ${child.children.length}');
  }
}
