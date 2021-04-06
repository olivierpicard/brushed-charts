import 'package:grapher/kernel/object.dart';
import '../incoming-data.dart';
import '../timeseries2D.dart';
import 'base.dart';

class ToTimeseries2D extends Filter {
  final String xLabel;
  final String yLabel;
  ToTimeseries2D(
      {required this.xLabel, required this.yLabel, GraphObject? child})
      : super(child);

  @override
  void onIncomingData(IncomingData input) {
    if (input.content is! Map) return;
    final x = input.content[xLabel];
    final y = input.content[yLabel];
    final dateTime = DateTime.parse(x);
    final timeseries = Timeseries2D(dateTime, y);
    propagate(IncomingData(timeseries));
  }
}
