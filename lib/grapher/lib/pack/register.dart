import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/pack/packet.dart';
import 'package:grapher/tag/tagged-box.dart';

class PacketRegister {
  final Map<int, Packet> _storage = {};

  void upsert(TaggedBox tag) {
    final timeseries = tag.content as Timeseries2D;
    final timestamp = timeseries.x.millisecondsSinceEpoch;
    _updateIfContainKey(timestamp, tag);
    _addIfDontContainKey(timestamp, tag);
  }

  void _addIfDontContainKey(int timestamp, TaggedBox tag) {
    if (_storage.containsKey(timestamp)) return;
    _storage[timestamp] = Packet(tag);
  }

  void _updateIfContainKey(int timestamp, TaggedBox tag) {
    if (!_storage.containsKey(timestamp)) return null;
    final packet = _storage[timestamp]!;
    packet.upsert(tag);
  }

  Packet? elementAt(DateTime dateTime) =>
      _storage[dateTime.millisecondsSinceEpoch];
}
