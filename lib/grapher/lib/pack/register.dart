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
    if (!_storage.containsKey(timestamp)) return;
    final packet = _storage[timestamp]!;
    packet.upsert(tag);
  }

  void removeTags(String tagName) {
    _storage.forEach((key, value) {
      value.yTags.removeWhere((element) => element.name == tagName);
    });
  }

  Packet? elementAt(DateTime dateTime) =>
      _storage[dateTime.millisecondsSinceEpoch];
}
