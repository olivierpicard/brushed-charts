import 'package:grapher/memory/memory.dart';

class MemoryEvent {
  final MemoryKV memoryInstance;
  final String key;
  final dynamic newValue;
  final dynamic oldValue;

  MemoryEvent(this.memoryInstance, this.key, this.oldValue, this.newValue);
}
