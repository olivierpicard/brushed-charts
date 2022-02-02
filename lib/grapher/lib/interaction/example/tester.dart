import 'package:flutter/services.dart';
import 'package:grapher/interaction/helper/keyboard.dart';
import 'package:grapher/pointer/example/tester.dart' as pointer;

class Tester extends pointer.Tester with KeyboardHelper {
  Tester() : super() {
    keyboardAddEventListeners();
  }

  @override
  void onKeyDown(KeyDownEvent event) {
    print('onKeyDown --- label: ${event.character}');
  }
}
