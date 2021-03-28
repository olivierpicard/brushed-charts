import 'package:flutter/material.dart';

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
            /* Expanded(
                child: Graph(
              kernel: createGraph(),
              child: Container(),
            )) */
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

  // GraphKernel createGraph() {
  //   final kernel = GraphKernel();
  //   final vlayout = VerticalLayout(kernel);
  //   final background1 = GraphBackground(kernel, Colors.cyan);
  //   final background2 = GraphBackground(kernel, Colors.red);
  //   final background3 = GraphBackground(kernel, Colors.yellow);
  //   background1.flexSize.pixel = Size(0, 70);
  //   background2.flexSize.pixel = Size(0, double.infinity);
  //   background3.flexSize.pixel = Size(0, 100);

  //   vlayout.children.add(background1);
  //   vlayout.children.add(background2);
  //   vlayout.children.add(background3);
  //   kernel.children.add(vlayout);
  //   return kernel;
  // }
}
