import 'package:grapher/model/JsonFilter/explode.dart';
import 'package:grapher/model/JsonFilter/extract.dart';
import 'package:grapher/model/JsonFilter/to-timeseries2D.dart';
import 'package:grapher/model/data-injector.dart';

import 'json.dart';
import '../model.dart';

Stream<Map> streamer(Map json) async* {
  yield json;
}

void main(List<String> args) async {
  final json = getMockJSON();
  final model = Model();
  DataInjector(
      stream: streamer(json),
      child: Extract(
          options: "data.getCandles",
          child: Explode(
              child: ToTimeseries2D(
                  xLabel: "date", yLabel: "mid", child: model))));
  await Future.delayed(Duration(seconds: 1));
  model.data.forEach((entry) => print(entry.x));
}
