import 'package:grapher/drawUnit/factory.dart';
import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pack/example/json-oanda.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/view/window.dart';

import 'package:flutter/material.dart';
import '/kernel/kernel.dart';
import '/pointer/widget.dart';

main(List<String> args) async {
  runApp(App());
}

Stream<Map> streamer(Map json) async* {
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
    final json = getMockOandaJSON();
    return GraphKernel(
        child: DataInjector(
            stream: streamer(json),
            child: Extract(
                options: "data.oanda",
                child: Explode(
                    child: ToCandle2D(
                        xLabel: "datetime",
                        yLabel: "price",
                        child: SortAccumulation(
                            child: Window(
                                child: StackLayout(children: [
                          DrawUnitFactory(template: Candlestick()),
                        ]))))))));
  }
}
