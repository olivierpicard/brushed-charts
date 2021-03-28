import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/widget.dart';
import 'package:pointer/widget.dart';
import 'package:splitter/horizontal.dart';
import 'package:staticLayout/stack.dart';
import 'background.dart';
import 'package:staticLayout/horizontal.dart';

import '../vertical.dart';
import 'circleLeft.dart';
import 'circleRight.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final kernel = createGraph();
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: GraphPointer(
              propagator: kernel,
              child: Graph(
                kernel: kernel,
              ),
            ))
          ],
        ),
      ),
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
    );
  }

  GraphKernel createGraph() {
    return GraphKernel(
        child: VerticalSplitter(children: [
      GraphBackground(color: Colors.cyan, length: "70px"),
      GraphBackground(color: Colors.red),
      StackLayout(children: [
        GraphBackground(color: Colors.yellow, length: "100px"),
        CircleRight(),
        CircleLeft(),
      ]),
      HorizontalSplitter(
        children: [
          HorizontalLayout(children: [
            GraphBackground(color: Colors.deepPurple),
            GraphBackground(color: Colors.deepOrange),
          ]),
          GraphBackground(color: Colors.blueGrey, length: "70%"),
        ],
      ),
    ]));
  }
}
