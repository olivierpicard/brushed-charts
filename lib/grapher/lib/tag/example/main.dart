import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/kernel/kernel.dart';

import '../tag.dart';
import 'json-oanda.dart';
import 'tester.dart';

import 'package:flutter/material.dart';
import '/kernel/kernel.dart';
import '/pointer/widget.dart';

main(List<String> args) async {
  runApp(App());
}

Stream<Map> streamerOanda(Map json) async* {
  yield json;
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
    final oandaJSON = getMockOandaJSON();
    return GraphKernel(
        child: DataInjector(
            stream: streamerOanda(oandaJSON),
            child: Extract(
                options: "data.oanda",
                child: Explode(
                    child: ToCandle2D(
                        xLabel: "datetime",
                        yLabel: "price",
                        child: Tag(name: 'tag_test', child: Tester()))))));
  }
}
