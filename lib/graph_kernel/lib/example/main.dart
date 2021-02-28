import 'package:flutter/material.dart';
import '../kernel.dart';
import '../widget.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: getThemeData(),
        home: Scaffold(body: Graph(kernel: GraphKernel())));
  }

  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
    );
  }
}
