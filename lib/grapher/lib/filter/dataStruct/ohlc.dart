class OHLC {
  final double open, high, low, close;

  OHLC(Map<String, dynamic> map)
      : open = map['open']! as double,
        high = map['high']! as double,
        low = map['low']! as double,
        close = map['close']! as double;
}
