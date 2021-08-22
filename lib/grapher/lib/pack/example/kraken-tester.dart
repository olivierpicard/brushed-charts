import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class KrakenTester extends Viewable with EndlinePropagator {
  static const double IMPOSSIBLE_NUMBER = 0;
  KrakenTester() {}

  void draw(ViewEvent event) {
    final chain = event.chainData;
    int counter = 0;

    for (final item in chain) {
      final close = item?.y.close;
      if (close == null) continue;
      if (close < 100) {
        print('kraken bitcoin test fail');
        return;
      }
      counter++;
    }
    print('kraken bitcoin test succeed: ($counter)');
  }
}
