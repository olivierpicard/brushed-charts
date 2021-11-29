import 'package:grapher/kernel/object.dart';

class FragmentStruct {
  final List<GraphObject> parse, visualisation, iteraction;
  FragmentStruct(
      {this.parse = const <GraphObject>[],
      this.visualisation = const <GraphObject>[],
      this.iteraction = const <GraphObject>[]});
}
