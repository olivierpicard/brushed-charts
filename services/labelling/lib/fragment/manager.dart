import 'package:flutter/material.dart';
import 'package:labelling/fragment/price.dart';
import 'package:labelling/services/source.dart';

class FragmentManager {
  final fragments = <PriceFragment>[];
  BuildContext? context;

  void updateSource(SourceService source) {
    for (var frag in fragments) {
      frag.updateSource(source);
    }
  }
}
