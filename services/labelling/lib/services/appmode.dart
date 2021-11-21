import 'package:flutter/material.dart';

enum AppMode { free, selection }

class AppModeService extends ChangeNotifier {
  var _mode = AppMode.free;

  AppMode get mode => _mode;
  set mode(AppMode value) {
    _mode = value;
    notifyListeners();
  }
}
