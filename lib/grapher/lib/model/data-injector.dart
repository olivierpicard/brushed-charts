import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'incoming-data.dart';

class DataInjector extends GraphObject with SinglePropagator {
  DataInjector({required Stream stream, GraphObject? child}) {
    Init.child(this, child);
    stream.listen((data) => propagate(IncomingData(data)));
  }
}
