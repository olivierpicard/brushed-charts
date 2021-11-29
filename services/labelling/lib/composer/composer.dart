import 'package:flutter/material.dart';
import 'package:labelling/fragment/manager.dart';

class GraphComposer extends StatefulWidget {
  final manager = FragmentManager();
  GraphComposer({Key? key}) : super(key: key);

  @override
  _GraphComposerState createState() => _GraphComposerState();
}

class _GraphComposerState extends State<GraphComposer> {
  @override
  Widget build(BuildContext context) {
    widget.manager.context = context;
    return Container();
  }
}
