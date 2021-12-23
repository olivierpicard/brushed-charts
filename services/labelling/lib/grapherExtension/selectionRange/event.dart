import 'package:grapher/filter/dataStruct/timeseries2D.dart';

class SelectionRangeEvent {
  DateTime? from, to;
  SelectionRangeEvent(this.from, this.to);
}
