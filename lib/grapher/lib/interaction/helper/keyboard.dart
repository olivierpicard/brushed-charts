import 'package:flutter/services.dart';
import 'package:grapher/kernel/drawable.dart';

mixin KeyboardHelper on Drawable {
  void keyboardAddEventListeners() {
    eventRegistry.add(KeyDownEvent, (e) => handleKeyEvent(e));
  }

  void handleKeyEvent(KeyDownEvent event) {
    print("key registry");
    onKeyDown(event);
    propagate(event);
  }

  void onKeyDown(KeyDownEvent event);
}
