import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class OandaTester extends Viewable with EndlinePropagator {
  static const double IMPOSSIBLE_NUMBER = 100;
  OandaTester() {}

  void draw(ViewEvent event) {
    final chain = event.chainData;
    int counter = 0;

    for (final item in chain) {
      final close = item?.y.close;
      if (close == null) continue;
      if (close > 3) {
        print('oanda test fail');
        return;
      }
      counter++;
    }
    print('oanda test succeed: ($counter)');
  }
}
