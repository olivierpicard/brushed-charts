import 'dart:math';

import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/filter/dataStruct/timeseries2D.dart';
import 'package:grapher/tag/tagged-box.dart';

class Packet extends Timeseries2D {
  double yMin = 99999999999, yMax = -99999999999;

  Packet(TaggedBox tag) : super((tag.content as Data2D).x, [tag]) {
    _updateYRange(tag);
  }

  void upsert(TaggedBox tag) {
    if (!_contains(tag)) {
      yTags.add(tag);
      return;
    }
    _updateItem(tag);
    _updateYRange(tag);
  }

  Timeseries2D? getByTagName(String tagName) {
    final index = _getTagNameIndex(tagName);
    if (index == -1) return null;
    final tag = yTags[index];
    final originalData = tag.content;

    return originalData;
  }

  void _updateYRange(TaggedBox tag) {
    final data2D = tag.content as Data2D;
    yMin = min(yMin, data2D.yMin);
    yMax = max(yMax, data2D.yMax);
  }

  bool _contains(TaggedBox tag) {
    final index = _getTagNameIndex(tag.name);
    if (index == -1) return false;

    return true;
  }

  int _getTagNameIndex(String tagName) {
    final index = yTags.indexWhere((element) {
      return element.name == tagName;
    });

    return index;
  }

  void _updateItem(TaggedBox tag) {
    final yTags = super.y as List<TaggedBox>;
    final index = _getTagNameIndex(tag.name);
    yTags[index] = tag;
  }

  void unlink() {
    if (previous == null && next == null) return;
    super.unlink();
  }

  List<TaggedBox> get y => super.y as List<TaggedBox>;
  List<TaggedBox> get yTags => this.y;
}
