import 'package:grapher/drawUnit/helper/metadata.dart';
import 'package:grapher/drawUnit/instanciable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/multi.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

import 'drawunit.dart';

class DrawUnitFactory extends Viewable with MultiPropagator {
  List<GraphObject> children = [];
  final DrawUnitObject template;
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
      final drawUnit = DrawUnit(metadata, template);
      children.add(drawUnit);
    });
  }
}
