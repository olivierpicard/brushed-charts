class ChunkRange {
  final double min, mid, max;
  ChunkRange(this.min, this.max) : mid = (max - min) / 2;
}
