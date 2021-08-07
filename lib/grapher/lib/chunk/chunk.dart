import 'package:grapher/chunk/metadata.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';

class Chunk extends GraphObject with SinglePropagator {
  GraphObject? child;
  Data2D data;
  ChunkMetadata metadata;
  final Chunk? previous;

  Chunk(this.data, this.metadata, this.previous, {this.child});
}
