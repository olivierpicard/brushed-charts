import 'package:grapher/kernel/object.dart';
import '../incoming-data.dart';

import 'base.dart';

class Explode extends Filter {
  Explode({GraphObject? child}) : super(child);

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! List) return;
    for (final item in input.content) {
      propagate(IncomingData(item));
    }
  }
}
