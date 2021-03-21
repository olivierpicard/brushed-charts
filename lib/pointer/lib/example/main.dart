import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/widget.dart';
import '../widget.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final kernel = GraphKernel();
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Container(color: Colors.blue, height: 200, width: 200),
            Expanded(
                child: GraphPointer(
              propagator: kernel,
              child: Graph(kernel: kernel),
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
}
