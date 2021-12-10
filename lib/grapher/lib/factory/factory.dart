import 'package:grapher/drawUnit/drawunit.dart';
import 'package:grapher/kernel/linkEvent.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

import 'metadata.dart';

class DrawUnitFactory extends Viewable with MultiPropagator {
  List<GraphObject> children = [];
  final DrawUnit template;
  late ViewEvent viewEvent;

  DrawUnitFactory({required this.template});

  @override
  void draw(ViewEvent event) {
    super.draw(event);
    viewEvent = event;
    createUnit();
    Init.children(this, children);
  }

  void createUnit() {
    children = [];
    final reversedData = viewEvent.chainData.toList().reversed;
    reversedData.forEach((item) {
      final metadata = MetadataHelper.make(this, item);
      final drawUnit = template.instanciate(metadata);
      drawUnit.handleEvent(metadata.viewEvent);
      children.add(drawUnit);
    });
    propagate(KernelLinkEvent(kernel!));
  }
}
