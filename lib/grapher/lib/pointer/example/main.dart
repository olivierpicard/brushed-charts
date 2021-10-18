import 'package:flutter/material.dart';
import 'package:grapher/pointer/example/tester.dart';
import '/kernel/kernel.dart';
import '../widget.dart';

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
            Container(color: Colors.blue, height: 200, width: 200),
            Expanded(
                child: GraphPointer(
              kernel: GraphKernel(child: Tester()),
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
