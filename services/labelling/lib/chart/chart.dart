import 'package:flutter/material.dart';
import 'package:grapher/kernel/kernel.dart';
import 'package:grapher/pointer/widget.dart';

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphPointer(kernel: GraphKernel());
  }

  void onFreshData(Map<String, dynamic> data) {}
}
