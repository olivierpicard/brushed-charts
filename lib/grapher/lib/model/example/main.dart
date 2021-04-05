import 'json.dart';
import '../jsonFilter.dart';

import '../model.dart';

Stream<Map> streamer(Map json) async* {
  yield json;
}

void main(List<String> args) async {
  final json = getMockJSON();
  final model = Model(
      stream: JsonFilter.toTimeseries2D(
          xLabel: "date",
          yLabel: "mid",
          stream: JsonFilter.explode(
              stream: JsonFilter.extract(
                  stream: streamer(json), options: "data.getCandles"))));
  await Future.delayed(Duration(seconds: 1));
  model.linkedData.forEach((entry) => print(entry.x));
}
