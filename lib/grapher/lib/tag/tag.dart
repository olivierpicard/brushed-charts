import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/tag/property.dart';
import 'package:grapher/tag/tagged-box.dart';

typedef dynamic BasicFunction(dynamic);

class Tag extends GraphObject with SinglePropagator {
  final GraphObject? child;
  final String name;
  final TagProperty property;

  Tag({required this.name, this.property = TagProperty.basic, this.child}) {
    Init.child(this, child);
    eventRegistry.add(IncomingData, (e) => onIncommingEvent(e as IncomingData));
  }

  void onIncommingEvent(IncomingData inputToTag) {
    final content = inputToTag.content;
    final tag = TaggedBox(name, property, content);
    final event = IncomingData(tag);
    propagate(event);
  }
}
