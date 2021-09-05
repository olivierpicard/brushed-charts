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
    propagateUnpackedChain(viewEvent);
  }

  void propagateUnpackedChain(ViewEvent viewEvent) {
    final packedChain = viewEvent.chainData;
    final matchingChain = extractPacket(packedChain);
    final event = makeViewEvent(matchingChain, viewEvent);
    propagate(event);
  }

  List<Timeseries2D?> extractPacket(Iterable chain) {
    final packets = chain.cast<Packet>();
    final matchingChain = packets.map((item) => item.getByTagName(tagName));
    return matchingChain.toList();
  }

  ViewEvent makeViewEvent(List<Timeseries2D?> chain, ViewEvent baseEvent) {
    final copiedEvent = ViewEvent.copy(baseEvent);
    copiedEvent.chainData = chain;
    return copiedEvent;
  }
}
