import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class ChunkFactoryTester extends Viewable with SinglePropagator {
  final DrawUnitFactory child;
  ChunkFactoryTester({required this.child});

  void draw(ViewEvent event) {
    propagate(event);
    for (var item in child.children) {
      item = item as DrawUnit;
      final drawZone = item.metadata.viewEvent.drawZone;
      print('startPos: ${drawZone.position.dx}' +
          ' - endPos: ${drawZone.position.dx + drawZone.size.width}' +
          ' - childType: ${item.child.runtimeType}');
    }
    print('Chunk count: ${child.children.length}');
    print('-------');
  }
}
