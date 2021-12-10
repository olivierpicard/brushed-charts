import 'package:flutter/material.dart';
import 'package:grapher/kernel/linkEvent.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

import 'misc/Init.dart';

abstract class AbstractKernel extends ChangeNotifier
    with SinglePropagator, GraphObject
    implements CustomPainter {
  AbstractKernel(GraphObject? child) {
    Init.child(this, child);
    kernel = this;
    propagate(KernelLinkEvent(this));
  }

  @override
  void onKernelLinkEvent(KernelLinkEvent event) {
    super.onKernelLinkEvent(event);
  }
}
