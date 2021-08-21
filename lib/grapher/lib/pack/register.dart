import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/pack/packet.dart';
import 'package:grapher/tag/tagged-box.dart';

class PacketRegister {
  final Map<DateTime, Packet> _storage = {};

  void upsert(TaggedBox tag) {
    final timeseries = tag.content as Timeseries2D;
    DateTime time = timeseries.x;
    _addIfDontContainKey(time, tag);
    _updateIfContainKey(time, tag);
  }

  void _addIfDontContainKey(DateTime time, TaggedBox tag) {
    if (_storage.containsKey(time)) return;
    _storage[time] = Packet(tag);
  }

  void _updateIfContainKey(DateTime time, TaggedBox tag) {
    if (!_storage.containsKey(time)) return null;
    final packet = _storage[time]!;
    packet.upsert(tag);
  }

  Packet? elementAt(DateTime dateTime) => _storage[dateTime];
}
