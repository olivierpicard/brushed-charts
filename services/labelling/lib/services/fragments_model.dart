import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';

class FragmentMetadata {
  final String fragmentName;
  FragmentMetadata(this.fragmentName);
}

class FragmentModel extends ChangeNotifier {
  final SourceService source;
  final List<FragmentMetadata> metadata;

  FragmentModel(this.source, [FragmentModel? old])
      : metadata = old?.metadata ?? [] {
    add('price');
  }

  void add(String name) {
    if (metadataContains(name) || !source.isValid()) return;
    metadata.add(FragmentMetadata(name));
    notifyListeners();
  }

  void remove(String name) {
    metadata.removeWhere((item) => item.fragmentName == name);
    notifyListeners();
  }

  bool metadataContains(String name) {
    for (final mdata in metadata) {
      if (mdata.fragmentName == name) return true;
    }
    return false;
  }
}
