import 'package:grapher/kernel/kernel.dart';

import 'package:flutter/material.dart';
import 'package:grapher/pipe/example/testEvent.dart';
import 'package:grapher/pipe/example/testerReceiver.dart';
import 'package:grapher/pipe/example/testerSender.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/staticLayout/stack.dart';
import '/kernel/kernel.dart';
import '/pointer/widget.dart';

main(List<String> args) async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final graph = createGraph();
    return MaterialApp(
      theme: getThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GraphPointer(kernel: graph),
            )
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
        child: StackLayout(children: [
      TesterSend(child: PipeIn(name: "pipeTest", eventType: TestEvent)),
      PipeOut(name: "pipeTest", child: TesterReceiver())
    ]));
  }
}
