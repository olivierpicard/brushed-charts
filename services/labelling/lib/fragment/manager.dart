import 'package:flutter/material.dart';
import 'package:labelling/fragment/fragment_contract.dart';
import 'package:labelling/fragment/no_data.dart';
import 'package:labelling/fragment/price.dart';
import 'package:labelling/services/fragments_model.dart';

class FragmentManager extends ChangeNotifier {
  late final List<FragmentContract> fragments;
  final FragmentModel model;

  FragmentManager(this.model, [FragmentManager? oldManager]) {
    if (!shouldUpdate(oldManager)) {
      fragments = oldManager!.fragments;
      return;
    }
    if (model.metadata.isEmpty) {
      fragments = buildDefaultFragment();
      return;
    }
    fragments = buildFragments();
  }

  bool shouldUpdate(FragmentManager? oldManager) {
    if (oldManager == null) return true;
    if (oldManager.model == model) return false;
    if (!model.source.isValid()) return false;
    return true;
  }

  List<FragmentContract> buildDefaultFragment() {
    return [NoDataFragment()];
  }

  List<FragmentContract> buildFragments() {
    final fragments = <FragmentContract>[];
    for (final meta in model.metadata) {
      fragments.add(getFragmentTypeByMetadata(meta));
    }
    return fragments;
  }

  FragmentContract getFragmentTypeByMetadata(FragmentMetadata metadata) {
    switch (metadata.fragmentName) {
      case 'price':
        return PriceFragment(metadata, model.source, updateState);
      default:
        throw Exception('No type was found for the given metadata');
    }
  }

  void updateState() {
    notifyListeners();
  }
}
