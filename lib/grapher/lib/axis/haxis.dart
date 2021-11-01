import 'package:grapher/axis/base.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class HorizontalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '60px';
  HorizontalAxis({GraphObject? child}) : super(child);
}
