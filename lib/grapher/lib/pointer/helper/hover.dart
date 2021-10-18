import 'package:flutter/gestures.dart';
import 'package:grapher/pointer/hover-wrapper.dart';

import '/kernel/drawable.dart';

mixin HoverHelper on Drawable {
  void hoverAddEventListeners() {
    eventRegistry.add(PointerHoverEventWrapper, (e) => handleHover(e));
  }

  void handleHover(PointerHoverEventWrapper wrap) {
    onHover(wrap.event);
    propagate(wrap);
  }

  void onHover(PointerHoverEvent event);
}
