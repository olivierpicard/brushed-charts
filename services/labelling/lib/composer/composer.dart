import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';
import 'package:provider/provider.dart';

class GraphComposer extends StatefulWidget {
  const GraphComposer({Key? key}) : super(key: key);

  @override
  _GraphComposerState createState() => _GraphComposerState();
}

class _GraphComposerState extends State<GraphComposer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SourceService>(
      builder: onSourceChange,
      child: Container(),
    );
  }

  Widget onSourceChange(
      BuildContext context, SourceService source, Widget? child) {
    print('SOurce changed');
    return Container();
  }
}
