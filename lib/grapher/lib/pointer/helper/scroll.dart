import 'package:flutter/gestures.dart';
import 'package:grapher/pointer/scroll-wrapper.dart';

import '/kernel/drawable.dart';

mixin ScrollHelper on Drawable {
  void scrollAddEventListeners() {
    eventRegistry.add(PointerScrollEventWrapper, (e) => onScroll(e.event));
  }

  void onScroll(PointerScrollEvent event);
}
