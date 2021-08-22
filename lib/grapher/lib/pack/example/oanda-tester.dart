import 'package:grapher/filter/dataStruct/candle.dart';
import 'package:grapher/filter/dataStruct/ohlc.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class OandaTester extends Viewable with EndlinePropagator {
  OandaTester() {}

  void draw(ViewEvent event) {
    final chain = event.chainData;
    for (final item in chain) {
      final close = item.y.close;
      if (close > 3) {
        print('oanda test fail');
        return;
      }
    }
    print('oanda test succeed');
  }
}
