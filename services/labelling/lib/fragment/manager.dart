import 'package:flutter/material.dart';
import 'package:grapher/staticLayout/stack.dart';
import 'package:labelling/fragment/fragment.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/no_data.dart';
import 'package:labelling/services/fragments_model.dart';

class FragmentManager {
  final fragments = <FragmentContract>[];
  final FragmentModel model;

  FragmentManager(this.model) {
    if (model.metadata.isEmpty) {
      addDefaultFragment();
      return;
    }
  }

  void addDefaultFragment() {
    fragments.add(NoDataFragment());
  }
}
