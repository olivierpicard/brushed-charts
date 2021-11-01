import 'package:grapher/flex/object.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class SizedObject extends FlexObject with SinglePropagator {
  GraphObject? child;
  SizedObject({String length = 'auto', this.child}) : super(length: length);
}
