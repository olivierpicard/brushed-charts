import 'package:flutter/material.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pointer/widget.dart';
import 'package:grapher/staticLayout/horizontal.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/manager.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/grapherExtension/axed_graph.dart';
import 'package:labelling/grapherExtension/centered_text.dart';
import 'package:labelling/grapherExtension/fragmented_graph.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class GraphComposer extends StatefulWidget {
  const GraphComposer({Key? key}) : super(key: key);

  @override
  _GraphComposerState createState() => _GraphComposerState();
}

class _GraphComposerState extends State<GraphComposer> {
  late List<FragmentContract> fragments;

  @override
  Widget build(BuildContext context) {
    return Consumer<FragmentManager>(
      builder: (context, manager, child) {
        fragments = manager.fragments;
        return compose();
      },
    );
  }

  Widget compose() {
    final composedStruct = buildGrouppedSubgraphs();
    return GraphPointer(
        kernel: GraphKernel(
            child: AxedGraph(graph: FragmentedGraph(struct: composedStruct))));
  }

  FragmentStruct buildGrouppedSubgraphs() {
    return FragmentStruct(
        parser: stackParserSubgraph(),
        visualisation: stackVisualSubgraph(),
        iteraction: stackInteractionSubgraph());
  }

  GraphObject stackVisualSubgraph() {
    final subgraph = <GraphObject>[];
    for (final fragment in fragments) {
      final visualObject = fragment.subgraph.visualisation;
      if (visualObject == null) continue;
      subgraph.add(visualObject);
    }

    return StackLayout(children: subgraph);
  }

  GraphObject stackParserSubgraph() {
    final subgraph = <GraphObject>[];
    for (final fragment in fragments) {
      final parserObject = fragment.subgraph.visualisation;
      if (parserObject == null) continue;
      subgraph.add(parserObject);
    }

    return StackLayout(children: subgraph);
  }

  GraphObject stackInteractionSubgraph() {
    final subgraph = <GraphObject>[];
    for (final fragment in fragments) {
      final visualObject = fragment.subgraph.visualisation;
      if (visualObject == null) continue;
      subgraph.add(visualObject);
    }

    return StackLayout(children: subgraph);
  }
}
