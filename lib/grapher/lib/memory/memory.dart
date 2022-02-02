import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/memory/event.dart';

class MemoryKV extends GraphObject with SinglePropagator {
  final _memory = <String, dynamic>{};

  void upsert(String key, dynamic value) {
    final oldValue = _memory[key];
    _memory[key] = value;
    _notifyChange(key, oldValue);
  }

  void remove(String key) {
    final oldValue = _memory[key];
    _memory.remove(key);
    _notifyChange(key, oldValue);
  }

  dynamic get(String key) {
    return _memory[key];
  }

  void _notifyChange(String key, dynamic oldValue) {
    final event = MemoryEvent(this, key, oldValue, _memory[key]);
    propagate(event);
  }
}
