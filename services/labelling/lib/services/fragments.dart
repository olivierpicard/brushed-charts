import 'package:flutter/material.dart';
import 'package:labelling/services/source.dart';

class FragmentModel extends ChangeNotifier {
  SourceService source;
  FragmentModel(this.source);
}
