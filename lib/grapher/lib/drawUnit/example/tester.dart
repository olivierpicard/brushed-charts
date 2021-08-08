import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

import '../factory.dart';

class ChunkFactoryTester extends Viewable with SinglePropagator {
  final DrawUnitFactory child;
  ChunkFactoryTester({required this.child});

  void draw(ViewEvent event) {
    propagate(event);
    print('Chunk count: ${child.children.length}');
  }
}
