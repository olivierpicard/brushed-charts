import 'package:grapher/kernel/propagator/endline.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class OandaMATester extends Viewable with EndlinePropagator {
  static const double IMPOSSIBLE_NUMBER = 100;
  OandaMATester() {}

  void draw(ViewEvent event) {
    final chain = event.chainData;
    int counter = 0;

    for (final item in chain) {
      final ma = item?.y;
      if (ma == null) continue;
      if (ma > 3) {
        print('oanda moving_average test fail');
        return;
      }
      counter++;
    }
    print('oanda moving_average test succeed: ($counter)');
  }
}
