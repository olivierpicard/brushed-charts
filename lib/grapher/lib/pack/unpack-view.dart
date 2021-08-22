import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pack/packet.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';

class UnpackFromViewEvent extends Viewable with SinglePropagator {
  final GraphObject? child;
  final String tagName;

  UnpackFromViewEvent({required this.tagName, this.child}) {
    Init.child(this, child);
  }

  void draw(ViewEvent viewEvent) {
    super.draw(viewEvent);
    final chainOriginal = viewEvent.chainData;
    final chainExtracted = extractPacket(chainOriginal);
    final newViewEvent = makeViewEvent(chainExtracted, viewEvent);
    propagate(newViewEvent);
  }

  List<Timeseries2D> extractPacket(Iterable chainData) {
    final packets = chainData;
    final timeseries = packets
        .map((e) {
          e = e as Packet;
          final timeseries = e.getByTagName(tagName);
          return timeseries;
        })
        .where((element) => (element != null))
        .cast<Timeseries2D>();

    return timeseries.toList();
  }

  ViewEvent makeViewEvent(List<Timeseries2D> chain, ViewEvent event) {
    final viewWithNewChain = ViewEvent(event, chain);
    return viewWithNewChain;
  }
}
