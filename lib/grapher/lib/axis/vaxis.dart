import 'package:grapher/axis/base.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class VerticalAxis extends AxisObject with SinglePropagator {
  static const DEFAULT_LENGTH = '40px';
  VerticalAxis({GraphObject? child}) : super(child);
}
