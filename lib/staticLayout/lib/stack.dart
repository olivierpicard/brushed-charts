import 'package:flex/resolver.dart';
import 'package:flutter/material.dart';
import 'package:kernel/drawEvent.dart';
import 'package:kernel/drawZone.dart';
import 'package:flex/object.dart';
import 'package:kernel/misc/Init.dart';
import 'package:kernel/object.dart';
import 'package:kernel/propagator/multi.dart';

class StackLayout extends FlexObject with MultiPropagator {
  StackLayout({required List<GraphObject> children}) {
    Init.children(this, children);
  }

  void draw(covariant DrawEvent drawEvent) {
    super.draw(drawEvent);
    propagate(drawEvent);
  }
}
