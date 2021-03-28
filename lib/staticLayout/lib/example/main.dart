import 'package:flex/length.dart';
import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/widget.dart';
import 'package:staticLayout/example/background.dart';
import 'package:staticLayout/example/circleLeft.dart';
import 'package:staticLayout/example/circleRight.dart';
import 'package:staticLayout/horizontal.dart';
import 'package:staticLayout/stack.dart';

import '../vertical.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Graph(
              kernel: createGraph(),
              child: Container(),
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
        child: VerticalLayout(children: [
      GraphBackground(color: Colors.cyan, length: "70px"),
      GraphBackground(color: Colors.red),
      StackLayout(children: [
        GraphBackground(color: Colors.yellow, length: "100px"),
        CircleRight(),
        CircleLeft(),
      ]),
      HorizontalLayout(children: [
        GraphBackground(color: Colors.deepPurple),
        GraphBackground(color: Colors.deepOrange),
        GraphBackground(color: Colors.blueGrey, length: "70%"),
      ])
    ]));
  }
}
