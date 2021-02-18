import 'event/sceneEvent.dart';

class EventRegistry {
  final _register = Map<String, Function>();

  add(String eventID, Function f) => _register[eventID] = f;
  remove(String eventID) => _register.remove(eventID);

  Function getCallback(String eventID) {
    Function f;
    try {
      f = _register[eventID];
    } catch (e) {
      print("No $eventID event found");
    }

    return f;
  }
}
