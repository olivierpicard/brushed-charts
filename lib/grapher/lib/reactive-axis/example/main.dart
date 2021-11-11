import 'package:grapher/axis/haxis.dart';
import 'package:grapher/axis/vaxis.dart';
import 'package:grapher/cell/cell.dart';
import 'package:grapher/cell/event.dart';
import 'package:grapher/cursor/haircross.dart';
import 'package:grapher/factory/factory.dart';
import 'package:grapher/filter/accumulate-sorted.dart';
import 'package:grapher/filter/data-injector.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/filter/json/explode.dart';
import 'package:grapher/filter/json/extract.dart';
import 'package:grapher/filter/json/to-candle2D.dart';
import 'package:grapher/filter/json/to-point2D.dart';
import 'package:grapher/geometry/candlestick.dart';
import 'package:grapher/geometry/line.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pack/pack.dart';
import 'package:grapher/pack/unpack-view.dart';
import 'package:grapher/pipe/pipeIn.dart';
import 'package:grapher/pipe/pipeOut.dart';
import 'package:grapher/reactive-axis/haxis.dart';
import 'package:grapher/reactive-axis/vaxis.dart';
import 'package:grapher/staticLayout/horizontal.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:grapher/staticLayout/vertical.dart';
import 'package:grapher/tag/tag.dart';
import 'package:grapher/utils/merge.dart';
import 'package:grapher/utils/sized-object.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/window.dart';

import 'package:flutter/material.dart';
import '/kernel/kernel.dart';
import '/pointer/widget.dart';
import 'json-oanda-ma.dart';
import 'json-oanda.dart';

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
    final oandaJSON = getMockOandaJSON();
    final maOandaJSON = getMockMAJSON();

    return GraphKernel(
        child: VerticalLayout(children: [
      HorizontalLayout(children: [
        StackLayout(children: [
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
                                  eventType: IncomingData,
                                  name: 'pipe_main')))))),
          DataInjector(
              stream: streamer(maOandaJSON),
              child: Extract(
                  options: "data.moving_average",
                  child: Explode(
                      child: ToPoint2D(
                          xLabel: "datetime",
                          yLabel: "value",
                          child: Tag(
                              name: 'moving_average',
                              child: PipeIn(
                                  eventType: IncomingData,
                                  name: 'pipe_main')))))),
          PipeOut(
              name: 'pipe_main',
              child: Pack(
                  child: SortAccumulation(
                      child: Window(
                          child: StackLayout(children: [
                PipeIn(name: 'pipe_axis', eventType: ViewEvent),
                UnpackFromViewEvent(
                    tagName: 'oanda',
                    child: DrawUnitFactory(
                        template: Cell.template(
                            child: Candlestick(
                                child: MergeBranches(
                                    child: PipeIn(
                                        name: 'pipe_cell_event',
                                        eventType: CellEvent)))))),
                UnpackFromViewEvent(
                    tagName: 'moving_average',
                    child: DrawUnitFactory(
                        template: Cell.template(
                            child: Line(
                                child: MergeBranches(
                                    child: PipeIn(
                                        name: 'pipe_cell_event',
                                        eventType: CellEvent)))))),
                PipeOut(name: 'pipe_cell_event', child: HairCross()),
              ])))))
        ]),
        SizedObject(
            length: VerticalAxis.DEFAULT_LENGTH,
            child: PipeOut(
                name: 'pipe_axis',
                child:
                    PipeOut(name: 'pipe_cell_event', child: ReactiveVAxis()))),
      ]),
      SizedObject(
          length: HorizontalAxis.DEFAULT_LENGTH,
          child: PipeOut(
              name: 'pipe_axis',
              child: PipeOut(name: 'pipe_cell_event', child: ReactiveHAxis()))),
    ]));
  }
}
