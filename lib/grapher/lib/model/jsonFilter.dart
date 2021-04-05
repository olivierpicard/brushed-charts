import 'timeseries2D.dart';

class JsonFilter {
  static Stream extract({
    required Stream stream,
    required String options,
  }) async* {
    await for (final map in stream) {
      if (map is! Map) continue;
      dynamic output = map;
      for (final wantedField in options.split('.')) {
        assert((output as Map).containsKey(wantedField));
        output = output[wantedField];
      }
      yield output;
    }
  }

  static Stream explode({required Stream stream}) async* {
    await for (final list in stream) {
      if (list is! List) continue;
      for (final item in list) {
        yield item;
      }
    }
  }

  static Stream<Timeseries2D> toTimeseries2D({
    required Stream stream,
    required String xLabel,
    required String yLabel,
  }) async* {
    await for (final map in stream) {
      if (map is! Map) continue;
      final x = map[xLabel];
      final y = map[yLabel];
      final dateTime = DateTime.parse(x);
      yield Timeseries2D(dateTime, y);
    }
  }
}
