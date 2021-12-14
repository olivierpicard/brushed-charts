import 'package:grapher/kernel/object.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/struct.dart';
import 'package:labelling/utils/null_graph_object.dart';

class UnifyFragment {
  final List<FragmentContract> _fragments;

  final _parser = <GraphObject?>[];
  final _visual = <GraphObject?>[];
  final _interaction = <GraphObject?>[];
  late final FragmentStruct _unifiedFragment;

  FragmentStruct get get => _unifiedFragment;

  UnifyFragment(this._fragments) {
    extractSubgraphFromFragment();
    removeNullValues();
    _unifiedFragment = makeUnifiedFragment();
  }

  void extractSubgraphFromFragment() {
    for (final fragment in _fragments) {
      final subgraph = fragment.subgraph;
      _parser.add(subgraph.parser);
      _visual.add(subgraph.visualisation);
      _interaction.add(subgraph.interaction);
    }
  }

  void removeNullValues() {
    _parser.removeWhere((element) => element == null);
    _visual.removeWhere((element) => element == null);
    _interaction.removeWhere((element) => element == null);
  }

  FragmentStruct makeUnifiedFragment() {
    return FragmentStruct(
        parser: listToStackLayout(_parser),
        visualisation: listToStackLayout(_visual),
        interaction: listToStackLayout(_interaction));
  }

  GraphObject listToStackLayout(List<GraphObject?> inputs) {
    if (inputs.isEmpty) return NullGraphObject();
    return StackLayout(children: inputs.cast<GraphObject>());
  }
}
