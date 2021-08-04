import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';

class DrawDataMix {
  final DrawEvent drawEvent;
  final Iterable<Data2D> data;
  DrawDataMix(this.drawEvent, this.data);
}
