class PrunePacketEvent {
  double from, to;
  String tagNameToPrune;
  PrunePacketEvent(
      {required this.tagNameToPrune,
      this.from = double.infinity,
      this.to = double.infinity});
}
