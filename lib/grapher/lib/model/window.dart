import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/model/model.dart';

import 'rangeData.dart';

class Window {
  static const CHUNK_LENGTH = 10.0;
  final Model model;
  final xChunkLength;
  DataRange? range;
  Window(this.model, [this.xChunkLength = Window.CHUNK_LENGTH]) {}

  Iterator? getIterator(DrawZone drawZone) {}

  tryInitRange(DrawZone drawZone) {
    if (range != null) return range;
  }
}
