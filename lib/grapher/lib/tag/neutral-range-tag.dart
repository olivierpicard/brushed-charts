import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/tag/tagged-box.dart';

typedef dynamic BasicFunction(dynamic);

class NeutralRangeTag extends Tag {
  final GraphObject? child;
  final String name;

  Tag({required this.name, this.child}) {
    Init.child(this, child);
    eventRegistry.add(IncomingData, (e) => onIncommingEvent(e as IncomingData));
  }

  void onIncommingEvent(IncomingData inputToTag) {
    final content = inputToTag.content;
    final tag = TaggedBox(name, content);
    final event = IncomingData(tag);
    propagate(event);
  }
}
