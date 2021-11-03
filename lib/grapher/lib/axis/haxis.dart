import 'package:grapher/axis/base.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';

class HorizontalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '30px';
  final margin = 50;
  final textWidth = 150;

  HorizontalAxis({GraphObject? child}) : super(child);

  @override
  void draw(DrawEvent event) {
    super.draw(event);
  }

  void drawAxis() {
    final dateRange = makeDateRange();
    final pRange = viewEvent!.xAxis.pixelRange;
    for(double d = dateRange.min, p = pRange.min; p < pRange.max; )
  }

  int getTimestampIncrementRate(Range dateRange) {
    dateRange.length / 
  }

  Range makeDateRange() {
    final first = (viewEvent!.chainData.first as Timeseries2D).timestamp;
    final last = (viewEvent!.chainData.first as Timeseries2D).timestamp;
    final dateRange = Range(first, last);
    return dateRange;
  }
}
