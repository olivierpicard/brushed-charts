import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/filter/incoming-data.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pack/packet.dart';
import 'package:grapher/pack/prune-event.dart';
import 'package:grapher/pack/register.dart';
import 'package:grapher/tag/tagged-box.dart';

class Pack extends GraphObject with SinglePropagator {
  final GraphObject? child;
  final packetRegistry = PacketRegister();

  Pack({this.child}) {
    Init.child(this, child);
    eventRegistry.add(IncomingData, (e) => onIncommingEvent(e as IncomingData));
    eventRegistry.add(
        PrunePacketEvent, (e) => onPrunePacket(e as PrunePacketEvent));
  }

  void onPrunePacket(PrunePacketEvent event) {
    packetRegistry.removeTags(event.tagNameToPrune);
  }

  void onIncommingEvent(IncomingData event) {
    ifWrongInput(event);
    ifValidInput(event);
  }

  void ifWrongInput(IncomingData event) {
    if (isValidTaggedTimeseries(event)) return;
    propagate(event);
  }

  bool isValidTaggedTimeseries(IncomingData event) {
    if (event.content is! TaggedBox) return false;
    final tag = event.content as TaggedBox;
    if (tag.content is! Timeseries2D) return false;
    return true;
  }

  void ifValidInput(IncomingData inputEvent) {
    if (!isValidTaggedTimeseries(inputEvent)) return;
    updateRegistry(inputEvent);
    final packet = getMatchingPacket(inputEvent);
    final outputEvent = IncomingData(packet);
    propagate(outputEvent);
  }

  Packet getMatchingPacket(IncomingData inputEvent) {
    final tag = inputEvent.content as TaggedBox;
    final datetime = (tag.content as Timeseries2D).x;
    final packet = packetRegistry.elementAt(datetime)!;
    packet.unlink();
    return packet;
  }

  void updateRegistry(IncomingData inputEvent) {
    final tag = inputEvent.content as TaggedBox;
    packetRegistry.upsert(tag);
  }
}
