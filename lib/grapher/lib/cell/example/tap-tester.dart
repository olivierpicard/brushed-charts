import 'package:flutter/material.dart';
import 'package:grapher/kernel/drawable.dart';
import 'package:grapher/kernel/misc/Init.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/pointer/helper/drag.dart';
import 'package:grapher/pointer/helper/hit.dart';

class TapTester extends Drawable with SinglePropagator, HitHelper {
  final GraphObject child;
  TapTester({required this.child}) {
    Init.child(this, child);
    hitAddEventListeners();
  }

  @override
  void onTapDown(covariant TapDownDetails event) {
    // print('test: ${event.globalPosition}');
  }
}
