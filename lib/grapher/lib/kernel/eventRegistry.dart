typedef EventHandler = void Function(dynamic);

class EventRegistry {
  final _register = Map<Type, EventHandler>();

  void add(Type eventType, EventHandler f) => _register[eventType] = f;
  void remove(Type eventType) => _register.remove(eventType);
  EventHandler? getCallback(Type eventType) => _register[eventType];
}
