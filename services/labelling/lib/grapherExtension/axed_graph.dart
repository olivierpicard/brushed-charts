import 'package:grapher/axis/haxis.dart';
import 'package:grapher/axis/vaxis.dart';
import 'package:grapher/cursor/haircross.dart';
import 'package:grapher/flex/object.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/reactive-axis/haxis.dart';
import 'package:grapher/reactive-axis/vaxis.dart';
import 'package:grapher/staticLayout/horizontal.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/staticLayout/vertical.dart';
import 'package:grapher/utils/sized-object.dart';

class AxedGraph extends GraphObject with SinglePropagator {
  final GraphObject graph;

  AxedGraph({required this.graph}) {
    child = buildGraph();
  }

  GraphObject buildGraph() {
    return VerticalLayout(children: [
      HorizontalLayout(children: [
        StackLayout(children: [graph]),
        buildVerticalAxis()
      ]),
      buildHorizontalAxis()
    ]);
  }

  SizedObject buildVerticalAxis() {
    return SizedObject(
        length: VerticalAxis.DEFAULT_LENGTH,
        child: PipeOut(
            name: 'pipe_axis',
            child: PipeOut(name: 'pipe_cell_event', child: ReactiveVAxis())));
  }

  SizedObject buildHorizontalAxis() {
    return SizedObject(
        length: HorizontalAxis.DEFAULT_LENGTH,
        child: PipeOut(
            name: 'pipe_axis',
            child: PipeOut(name: 'pipe_cell_event', child: ReactiveHAxis())));
  }
}
