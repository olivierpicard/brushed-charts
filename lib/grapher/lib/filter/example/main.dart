import '../accumulate-sorted.dart';
import '../data-injector.dart';
import 'json.dart';
import '../json/extract.dart';
import '../json/explode.dart';
import '../json/to-timeseries2D.dart';
import 'tester.dart';

Stream<Map> streamer(Map json) async* {
  yield json;
}

void main(List<String> args) {
  final json = getMockJSON();
  DataInjector(
      stream: streamer(json),
      child: Extract(
          options: "data.getCandles",
          child: Explode(
              child: ToTimeseries2D(
                  xLabel: "date",
                  yLabel: "mid",
                  child: SortAccumulation(child: Tester())))));
}
