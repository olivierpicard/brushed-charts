class Range {
  double min;
  double max;
  get length => max - min;

  Range(this.min, this.max);

  Range.copy(Range ref)
      : min = ref.min,
        max = ref.max;
}
