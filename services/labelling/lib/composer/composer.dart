import 'package:flutter/material.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/widget.dart';
import 'package:grapher/interaction/widget.dart';
import 'package:labelling/grapherExtension/selectionRange/aggregate.dart';
import 'package:labelling/composer/unifyFragment.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/manager.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/axed_graph.dart';
import 'package:labelling/grapherExtension/fragmented_graph.dart';
import 'package:labelling/utils/null_graph_object.dart';
import 'package:provider/provider.dart';

class GraphComposer extends StatefulWidget {
  const GraphComposer({Key? key}) : super(key: key);

  @override
  _GraphComposerState createState() => _GraphComposerState();
}

class _GraphComposerState extends State<GraphComposer> {
  late List<FragmentContract>? fragments;
  var fragmentStruct = FragmentStruct();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<FragmentManager>(
      key: widget.key,
      builder: (context, manager, child) {
        fragments = manager.fragments;
        return getAppropriateComposition();
      },
    );
  }

  Widget getAppropriateComposition() {
    var unifiedFragment = UnifyFragment(fragments!).get;
    if (unifiedFragment.parser is NullGraphObject) {
      return noAxisView(unifiedFragment);
    }
    SelectionRangeComposer(unifiedFragment).aggregate();
    return axedView(unifiedFragment);
  }

  Widget noAxisView(FragmentStruct unifiedFragment) {
    return Graph(kernel: GraphKernel(child: unifiedFragment.visualisation));
  }

  Widget axedView(FragmentStruct unifiedFragment) {
    return GraphFullInteraction(
        kernel: GraphKernel(
            child: AxedGraph(graph: FragmentedGraph(struct: unifiedFragment))));
  }
}
