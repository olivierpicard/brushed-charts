import 'package:grapher/flex/object.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

abstract class AxisObject extends Drawable with SinglePropagator {
  final GraphObject? child;
  AxisObject(this.child);
}
