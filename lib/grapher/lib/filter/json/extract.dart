import 'package:grapher/kernel/object.dart';

import '../base.dart';
import '../incoming-data.dart';

class Extract extends Filter {
  final String options;
  Extract({required this.options, GraphObject? child}) : super(child);

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! Map) return;
    dynamic output = input.content;
    for (final wantedField in options.split('.')) {
      final valueAtKey = output[wantedField];
      if (valueAtKey == null) return;
      output = valueAtKey;
    }
    propagate(IncomingData(output));
  }
}
