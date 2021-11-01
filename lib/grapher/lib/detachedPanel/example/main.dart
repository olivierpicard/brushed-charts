import 'package:flutter/material.dart';
import 'package:grapher/detachedPanel/align-options.dart';
import 'package:grapher/detachedPanel/example/backgound-red.dart';
import 'package:grapher/detachedPanel/example/backgound-yellow.dart';
import 'package:grapher/detachedPanel/panel.dart';
import 'package:grapher/kernel/widget.dart';
import 'package:grapher/staticLayout/stack.dart';
import '/kernel/kernel.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: getThemeData(),
        home: Scaffold(
            body: Container(
                child: Graph(
          kernel: GraphKernel(
              child: StackLayout(children: [
            FillBackgroundYellow(),
            DetachedPanel(
                height: 100,
                width: 70,
                vAlignment: VAlign.bottom,
                hAlignment: HAlign.right,
                vBias: 30,
                hBias: 20,
                child: FillBackgroundRed())
          ])),
        ))));
  }

  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
    );
  }
}
