import 'package:flutter/material.dart';
import 'package:kernel/main.dart';
import 'package:staticLayout/example/background.dart';
import 'package:staticLayout/main.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final kernel = GraphKernel();

    final graph = Graph(kernel: kernel);
    graph.
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Container(color: Colors.blue, height: 200, width: 200),
            Expanded(child: )
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
    /* final kernel = GraphKernel();
    final vlayout = VerticalLayout(kernel);
    final background1 = GraphBackground(kernel, Colors.cyan);
    final background2 = GraphBackground(kernel, Colors.red);
    final background3 = GraphBackground(kernel, Colors.yellow);
    background1.flexSize.pixel = Size(double.nan, 70);
    background1.flexSize.virtual = Size(100, double.nan);
    
    background2.flexSize.pixel = Size(double.nan, double.infinity);
    background3.flexSize.pixel = Size(double.infinity, 70); */
  }
}
