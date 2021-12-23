import 'package:grapher/cursor/haircross.dart';
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
import 'package:labelling/utils/null_graph_object.dart';

class FragmentedGraph extends GraphObject with SinglePropagator {
  FragmentedGraph({required FragmentStruct struct}) {
    child = buildCoreGraph(struct);
  }

  GraphObject buildCoreGraph(FragmentStruct fragmentStruct) {
    return StackLayout(children: [
      buildParser(fragmentStruct),
      buildVisualization(fragmentStruct),
      buildInteraction(fragmentStruct),
    ]);
  }

  GraphObject buildParser(FragmentStruct struct) {
    return struct.parser ?? NullGraphObject();
  }

  GraphObject buildVisualization(FragmentStruct struct) {
    return PipeOut(
        name: 'pipe_main',
        child: Pack(
            child: SortAccumulation(
                child: Window(
                    child: StackLayout(children: [
          struct.visualisation ?? NullGraphObject(),
          PipeIn(name: 'pipe_view_event', eventType: ViewEvent),
          PipeOut(name: 'pipe_cell_event', child: HairCross()),
        ])))));
  }

  GraphObject buildInteraction(FragmentStruct struct) {
    return struct.interaction ?? NullGraphObject();
  }
}
