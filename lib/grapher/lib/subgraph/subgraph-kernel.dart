import 'package:flutter/src/rendering/custom_paint.dart';
import 'dart:ui';

import 'package:grapher/kernel/abstractKernel.dart';
import 'package:grapher/kernel/linkEvent.dart';
import 'package:grapher/kernel/object.dart';

class SubGraphKernel extends AbstractKernel {
  final eventToPropagate = <dynamic>[];
  SubGraphKernel({GraphObject? child}) : super(child);

  @override
  void handleEvent(event) {
    listenSpecialEvent(event);
    retainEventsWhenKernelIsSelf(event);
    propagateWhenSelfIsNotKernel(event);
  }

  void retainEventsWhenKernelIsSelf(event) {
    if (kernel != this) return;
    eventToPropagate.add(event);
  }

  void propagateWhenSelfIsNotKernel(event) {
    if (kernel == this) return;
    propagate(event);
  }

  @override
  void onKernelLinkEvent(KernelLinkEvent event) {
    super.onKernelLinkEvent(event);
    releaseRetainedEvents();
    setState(this);
  }

  void releaseRetainedEvents() {
    if (kernel == this) return;
    releaseStoredEventToRootKernel();
    eventToPropagate.clear();
  }

  void releaseStoredEventToRootKernel() {
    for (final retainedEvent in eventToPropagate) {
      kernel!.propagate(retainedEvent);
    }
  }

  @override
  bool? hitTest(Offset position) {}

  @override
  void paint(Canvas canvas, Size size) => null;

  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
