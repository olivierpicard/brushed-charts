import 'package:flutter/material.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/model/JsonFilter/explode.dart';
import 'package:grapher/model/JsonFilter/extract.dart';
import 'package:grapher/model/JsonFilter/to-timeseries2D.dart';
import 'package:grapher/model/data-injector.dart';
import 'package:grapher/model/model.dart';
import 'package:grapher/view/drawer.dart';
import '/kernel/kernel.dart';
import '/kernel/widget.dart';
import '/staticLayout/stack.dart';
import 'json.dart';
import '../drawer.dart' as view;

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

  Stream<Map> streamer(Map json) async* {
    yield json;
  }

  GraphKernel createGraph() {
    final json = getMockJSON();
    return GraphKernel(
        child: DataInjector(
            stream: streamer(json),
            child: StackLayout(children: [
              Extract(
                  options: "data.getCandles",
                  child: Explode(
                      child: ToTimeseries2D(
                          xLabel: "date",
                          yLabel: "mid",
                          child: Model(
                              child: view.Drawer(
                                  geometryFactory: Candlestick.instanciate)))))
            ])));
  }
}
