import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/filter/json/to-point2D.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/pack/example/json-oanda-ma.dart';
import 'package:grapher/pack/example/oanda-tester.dart';
import 'package:grapher/pack/example/oanda_ma-tester.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/view/window.dart';

import '../pack.dart';
import 'json-oanda.dart';

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

  GraphObject oanda() {
    final oandaJSON = getMockOandaJSON();
    return DataInjector(
        stream: streamerOanda(oandaJSON),
        child: Extract(
            options: "data.oanda",
            child: Explode(
                child: ToCandle2D(
                    xLabel: "datetime",
                    yLabel: "price",
                    child: Tag(
                        name: 'oanda',
                        child: PipeIn(
                            eventType: IncomingData,
                            name: 'pipe_mainView'))))));
  }

  GraphObject oanda_ma() {
    final oandaMA_JSON = getMockMAJSON();
    return DataInjector(
        stream: streamerOanda(oandaMA_JSON),
        child: Extract(
            options: "data.moving_average",
            child: Explode(
                child: ToPoint2D(
                    xLabel: "datetime",
                    yLabel: "value",
                    child: Tag(
                        name: 'oanda_ma',
                        child: PipeIn(
                            eventType: IncomingData,
                            name: 'pipe_mainView'))))));
  }

  GraphObject testOanda() {
    return UnpackFromViewEvent(tagName: 'oanda', child: OandaTester());
  }

  GraphObject testOandaMA() {
    return UnpackFromViewEvent(tagName: 'oanda_ma', child: OandaMATester());
  }

  GraphKernel createGraph() {
    return GraphKernel(
        child: StackLayout(children: [
      oanda(),
      oanda_ma(),
      PipeOut(
          name: 'pipe_mainView',
          child: Pack(
              child: SortAccumulation(
                  child: Window(
                      child: StackLayout(
                          children: [testOanda(), testOandaMA()])))))
    ]));
  }
}
