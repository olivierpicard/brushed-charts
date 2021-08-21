import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/tag/tagged-box.dart';

class Tester extends GraphObject with EndlinePropagator {
  Tester() {
    eventRegistry.add(IncomingData, (event) => onEvent(event as IncomingData));
  }

  void onEvent(IncomingData event) {
    if (event.content is! TaggedBox) return;
    TaggedBox tag = event.content;
    if (tag.name == 'tag_test' && tag.content.y is OHLC) {
      print('test succeed');
    }
  }
}
