import 'package:grapher/chunk/factory.dart';
import 'package:grapher/chunk/metadata.dart';
import 'package:grapher/chunk/range.dart';

class MetadataMaker {
  final ChunkFactory facto;
  MetadataMaker(this.facto);

  ChunkMetadata make() {
    final xRange = makeXRange();
    final yRange = calculateYScale();
    final metadata = ChunkMetadata(xRange, yRange);

    return metadata;
  }

  ChunkRange makeXRange() {
    final chunkCount = facto.children.length;
    final chunkLength = facto.viewEvent.viewAxis.chunkLength;
    final start = chunkLength * chunkCount;
    final end = start + chunkLength;

    return ChunkRange(start, end);
  }

  double calculateYScale() {
    final min = getYMin();
    final max = getYMax();
    final originalLen = max - min;
    final zoneHeight = facto.viewEvent.drawZone.size.height;
    final scaleFactor = zoneHeight / originalLen;

    return scaleFactor;
  }

  double getYMin() {
    final data = facto.viewEvent.data;
    final min = data.reduce((prev, curr) {
      return (prev.yMin < curr.yMin) ? prev : curr;
    }).yMin;

    return min;
  }

  double getYMax() {
    final data = facto.viewEvent.data;
    final max = data.reduce((prev, curr) {
      return (prev.yMax > curr.yMax) ? prev : curr;
    }).yMax;

    return max;
  }
}
