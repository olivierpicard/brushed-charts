import 'package:grapher/drawUnit/factory.dart';
import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/geometry/example/json-kraken.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pack/example/json-oanda.dart';
import 'package:grapher/pack/pack.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/view/window.dart';

import 'package:flutter/material.dart';
import '../candlestickblue.dart';
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

  // GraphKernel createGraph() {
  //   final json = getMockOandaJSON();
  //   return GraphKernel(
  //       child: DataInjector(
  //           stream: streamer(json),
  //           child: Extract(
  //               options: "data.oanda",
  //               child: Explode(
  //                   child: ToCandle2D(
  //                       xLabel: "datetime",
  //                       yLabel: "price",
  //                       child: SortAccumulation(
  //                           child: Window(
  //                               child: DrawUnitFactory(
  //                                   template: Candlestick()))))))));
  // }

  GraphKernel createGraph() {
    final oandaJSON = getMockOandaJSON();
    final krakenJSON = getMockKrakenJSON();
    return GraphKernel(
        child: StackLayout(children: [
      DataInjector(
          stream: streamer(oandaJSON),
          child: Extract(
              options: "data.oanda",
              child: Explode(
                  child: ToCandle2D(
                      xLabel: "datetime",
                      yLabel: "price",
                      child: Tag(
                          name: 'oanda',
                          child: PipeIn(
                              eventType: IncomingData, name: 'pipe_main')))))),
      DataInjector(
          stream: streamer(krakenJSON),
          child: Extract(
              options: "data.kraken",
              child: Explode(
                  child: ToCandle2D(
                      xLabel: "datetime",
                      yLabel: "price",
                      child: Tag(
                          name: 'kraken',
                          child: PipeIn(
                              eventType: IncomingData, name: 'pipe_main')))))),
      PipeOut(
          name: 'pipe_main',
          child: Pack(
              child: SortAccumulation(
                  child: Window(
                      child: StackLayout(children: [
            UnpackFromViewEvent(
                tagName: 'oanda',
                child: DrawUnitFactory(template: Candlestick())),
            UnpackFromViewEvent(
                tagName: 'kraken',
                child: DrawUnitFactory(template: CandlestickBlue())),
          ])))))
    ]));
  }
}
