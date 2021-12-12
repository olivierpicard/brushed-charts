import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pack/pack.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/window.dart';
import 'package:labelling/fragment/struct.dart';

class FragmentedGraph extends GraphObject with SinglePropagator {
  FragmentedGraph({required FragmentStruct struct}) {
    child = buildCoreGraph(struct);
  }

  GraphObject buildCoreGraph(FragmentStruct fragmentStruct) {
    return StackLayout(children: [
      fragmentStruct.parser ?? StackLayout(children: []),
      buildMainPipe(fragmentStruct),
    ]);
  }

  GraphObject buildMainPipe(FragmentStruct struct) {
    return PipeOut(
        name: 'pipe_main',
        child: Pack(
            child: SortAccumulation(
                child: Window(
                    child: StackLayout(children: [
          PipeIn(name: 'pipe_axis', eventType: ViewEvent),
          struct.visualisation ?? StackLayout(children: [])
        ])))));
  }
}
