import 'package:flex/length.dart';
import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/widget.dart';
import 'package:staticLayout/example/background.dart';
import 'package:staticLayout/horizontal.dart';

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
    final kernel = GraphKernel();
    final vlayout = VerticalLayout(kernel);
    final hlayout = HorizontalLayout(kernel);
    final background1 = GraphBackground(kernel, Colors.cyan);
    final background2 = GraphBackground(kernel, Colors.red);
    final background3 = GraphBackground(kernel, Colors.yellow);
    final background4 = GraphBackground(kernel, Colors.green);
    background1.flexLength = FlexLength("70px");
    background2.flexLength = FlexLength(FlexLength.AUTO);
    background3.flexLength = FlexLength("100px");
    background4.flexLength = FlexLength("auto");

    vlayout.children.add(background1);
    vlayout.children.add(background2);
    vlayout.children.add(background3);
    vlayout.children.add(background4);
    kernel.children.add(vlayout);
    return kernel;
  }
}
