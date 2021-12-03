import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';

class FragmentMetadata {
  final String name;
  FragmentMetadata(this.name);
}

class FragmentModel extends ChangeNotifier {
  final SourceService _source;
  final List<FragmentMetadata> metadata;

  FragmentModel(this._source, [FragmentModel? old])
      : metadata = old?.metadata ?? [];

  void add(String name) {
    metadata.add(FragmentMetadata(name));
    notifyListeners();
  }

  void remove(String name) {
    metadata.removeWhere((item) => item.name == name);
    notifyListeners();
  }
}
