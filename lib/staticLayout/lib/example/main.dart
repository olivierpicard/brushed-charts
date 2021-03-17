import 'package:flutter/material.dart';
import 'package:kernel/main.dart';

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
}
