import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class KrakenTester extends Viewable with EndlinePropagator {
  KrakenTester() {}

  void draw(ViewEvent event) {
    final chain = event.chainData;
    for (final item in chain) {
      final close = item.y.close;
      if (close < 100) {
        print('kraken bitcoin test fail');
        return;
      }
    }
    print('kraken bitcoin test succeed');
  }
}
