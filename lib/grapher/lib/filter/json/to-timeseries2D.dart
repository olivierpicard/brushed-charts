import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/object.dart';

import '../base.dart';
import '../incoming-data.dart';

abstract class ToTimeseries2D extends Filter {
  final String xLabel;
  final String yLabel;

  ToTimeseries2D(this.xLabel, this.yLabel, GraphObject? child) : super(child);

  Timeseries2D instanciate(DateTime dateTime, dynamic y);

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! Map) return;
    final x = input.content[xLabel];
    final y = input.content[yLabel];
    final dateTime = DateTime.parse(x);
    if (y == null) return;
    final timeseries = instanciate(dateTime, y);
    propagate(IncomingData(timeseries));
  }
}
