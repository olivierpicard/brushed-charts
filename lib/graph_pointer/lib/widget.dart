import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graph_kernel/main.dart';
import 'package:pointer_interpreter/eventEmitter.dart';

class InteractionWidget extends StatelessWidget {
  final Widget child;
  final SceneWidget sceneWidget;
  final eventEmitter = EventEmitter();

  InteractionWidget({this.child}) : sceneWidget = SceneWidget(child: child);

  Widget build(BuildContext context) {
    return makeListenerWidget();
  }

  Listener makeListenerWidget() {
    return Listener(
      onPointerSignal: onScrollableEvent,
      child: makeGestureWidget(),
    );
  }

  onScrollableEvent(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    final scrollEvent = signal as PointerScrollEvent;
    print("scroll: ${scrollEvent.scrollDelta}");
  }

  GestureDetector makeGestureWidget() {
    return GestureDetector(
      onTapUp: (tapUpDetails) => print("tap: ${tapUpDetails.localPosition}"),
      onPanUpdate: (dragUpdateDetails) =>
          print("pan updates: ${dragUpdateDetails.delta}"),
      child: sceneWidget,
    );
  }
}
